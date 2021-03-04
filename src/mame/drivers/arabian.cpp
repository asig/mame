// license:BSD-3-Clause
// copyright-holders:Dan Boris
/***************************************************************************

    Sun Electronics Arabian hardware

    driver by Dan Boris

    Games supported:
        * Arabian [2 sets]

    Known bugs:
        * none at this time

****************************************************************************

    Memory map

****************************************************************************

    ========================================================================
    CPU #1 (Arabian)
    ========================================================================
    0000-7FFF   R     xxxxxxxx    Program ROM
    8000-BFFF   R/W   xxxxxxxx    Bitmap RAM
    C000        R     ----xxxx    Coin inputs
    C200        R     ----xxxx    Option switches
    D000-DFFF   R/W   xxxxxxxx    Custom microprocessor RAM
    E000          W   ----xxxx    BSEL Bank select
    E001          W   xxxxxxxx    DMA ROM start address low
    E002          W   xxxxxxxx    DMA ROM start address high
    E003          W   xxxxxxxx    DMA RAM start address low
    E004          W   xxxxxxxx    DMA RAM start address high
    E005          W   xxxxxxxx    Picture size/DMA start low
    E006          W   xxxxxxxx    Picture size/DMA start high
    ========================================================================
    C800          W   xxxxxxxx    Sound chip address
    CA00        R/W   xxxxxxxx    Sound chip data
    ========================================================================
    Interrupts:
        NMI not connected
        IRQ generated by VBLANK
    ========================================================================

***************************************************************************/

#include "emu.h"
#include "includes/arabian.h"

#include "cpu/z80/z80.h"
#include "sound/ay8910.h"
#include "screen.h"
#include "speaker.h"


/* constants */
#define MAIN_OSC        XTAL(12'000'000)


/*************************************
 *
 *  Audio chip output ports
 *
 *************************************/

void arabian_state::ay8910_porta_w(uint8_t data)
{
	/*
	    bit 7 = ENA
	    bit 6 = ENB
	    bit 5 = /ABHF
	    bit 4 = /AGHF
	    bit 3 = /ARHF
	*/
	m_video_control = data;
}


void arabian_state::ay8910_portb_w(uint8_t data)
{
	/*
	    bit 5 = /IREQ to custom CPU
	    bit 4 = /SRES to custom CPU
	    bit 1 = coin 2 counter
	    bit 0 = coin 1 counter
	*/

	m_mcu->set_input_line(MB88_IRQ_LINE, data & 0x20 ? CLEAR_LINE : ASSERT_LINE);
	m_mcu->set_input_line(INPUT_LINE_RESET, data & 0x10 ? CLEAR_LINE : ASSERT_LINE);

	/* clock the coin counters */
	machine().bookkeeping().coin_counter_w(1, ~data & 0x02);
	machine().bookkeeping().coin_counter_w(0, ~data & 0x01);
}



/*************************************
 *
 *  Custom CPU (MB8841 MCU)
 *
 *************************************/

uint8_t arabian_state::mcu_port_r0_r()
{
	uint8_t val = m_mcu_port_r[0];

	/* RAM mode is enabled */
	val |= 4;

	return val;
}

uint8_t arabian_state::mcu_port_r1_r()
{
	uint8_t val = m_mcu_port_r[1];

	return val;
}

uint8_t arabian_state::mcu_port_r2_r()
{
	uint8_t val = m_mcu_port_r[2];

	return val;
}

uint8_t arabian_state::mcu_port_r3_r()
{
	uint8_t val = m_mcu_port_r[3];

	return val;
}

void arabian_state::mcu_port_r0_w(uint8_t data)
{
	uint32_t ram_addr = ((m_mcu_port_p & 7) << 8) | m_mcu_port_o;

	if (~data & 2)
		m_custom_cpu_ram[ram_addr] = 0xf0 | m_mcu_port_r[3];

	m_flip_screen = data & 8;

	m_mcu_port_r[0] = data & 0x0f;
}

void arabian_state::mcu_port_r1_w(uint8_t data)
{
	m_mcu_port_r[1] = data & 0x0f;
}

void arabian_state::mcu_port_r2_w(uint8_t data)
{
	m_mcu_port_r[2] = data & 0x0f;
}

void arabian_state::mcu_port_r3_w(uint8_t data)
{
	m_mcu_port_r[3] = data & 0x0f;
}

uint8_t arabian_state::mcu_portk_r()
{
	uint8_t val = 0xf;

	if (~m_mcu_port_r[0] & 1)
	{
		uint32_t ram_addr = ((m_mcu_port_p & 7) << 8) | m_mcu_port_o;
		val = m_custom_cpu_ram[ram_addr];
	}
	else
	{
		static const char *const comnames[] = { "COM0", "COM1", "COM2", "COM3", "COM4", "COM5" };
		uint8_t sel = ((m_mcu_port_r[2] << 4) | m_mcu_port_r[1]) & 0x3f;
		int i;

		for (i = 0; i < 6; ++i)
		{
			if (~sel & (1 << i))
			{
				val = ioport(comnames[i])->read();
				break;
			}
		}
	}

	return val & 0x0f;
}

void arabian_state::mcu_port_o_w(uint8_t data)
{
	uint8_t out = data & 0x0f;

	if (data & 0x10)
		m_mcu_port_o = (m_mcu_port_o & 0x0f) | (out << 4);
	else
		m_mcu_port_o = (m_mcu_port_o & 0xf0) | out;
}

void arabian_state::mcu_port_p_w(uint8_t data)
{
	m_mcu_port_p = data & 0x0f;
}



/*************************************
 *
 *  Main CPU memory handlers
 *
 *************************************/

void arabian_state::main_map(address_map &map)
{
	map(0x0000, 0x7fff).rom();
	map(0x8000, 0xbfff).w(FUNC(arabian_state::arabian_videoram_w));
	map(0xc000, 0xc000).mirror(0x01ff).portr("IN0");
	map(0xc200, 0xc200).mirror(0x01ff).portr("DSW1");
	map(0xd000, 0xd7ff).mirror(0x0800).ram().share("custom_cpu_ram");
	map(0xe000, 0xe007).mirror(0x0ff8).w(FUNC(arabian_state::arabian_blitter_w)).share("blitter");
}



/*************************************
 *
 *  Main CPU port handlers
 *
 *************************************/

void arabian_state::main_io_map(address_map &map)
{
	map(0xc800, 0xc800).mirror(0x01ff).w("aysnd", FUNC(ay8910_device::address_w));
	map(0xca00, 0xca00).mirror(0x01ff).w("aysnd", FUNC(ay8910_device::data_w));
}



/*************************************
 *
 *  Port definitions
 *
 *************************************/

static INPUT_PORTS_START( arabian )
	PORT_START("IN0")
	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_COIN1 )
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_COIN2 )
	PORT_SERVICE( 0x04, IP_ACTIVE_HIGH )                    /* also adds 1 credit */
	PORT_BIT( 0xf8, IP_ACTIVE_HIGH, IPT_UNKNOWN )

	PORT_START("DSW1")
	PORT_DIPNAME( 0x01, 0x00, DEF_STR( Lives ) )            PORT_DIPLOCATION("SW1:!1")
	PORT_DIPSETTING(    0x00, "3" )
	PORT_DIPSETTING(    0x01, "5" )
	PORT_DIPNAME( 0x02, 0x02, DEF_STR( Cabinet ) )          PORT_DIPLOCATION("SW1:!2")
	PORT_DIPSETTING(    0x02, DEF_STR( Upright ) )
	PORT_DIPSETTING(    0x00, DEF_STR( Cocktail ) )
	PORT_DIPNAME( 0x04, 0x04, DEF_STR( Flip_Screen ) )      PORT_DIPLOCATION("SW1:!3")
	PORT_DIPSETTING(    0x04, DEF_STR( Off ) )
	PORT_DIPSETTING(    0x00, DEF_STR( On ) )
	PORT_DIPNAME( 0x08, 0x00, DEF_STR( Difficulty ) )       PORT_DIPLOCATION("SW1:!4")    /* Carry Bowls to Next Life */
	PORT_DIPSETTING(    0x00, DEF_STR( Easy ) )             /* not reset "ARABIAN" letters */
	PORT_DIPSETTING(    0x08, DEF_STR( Hard ) )             /* reset "ARABIAN" letters */
	PORT_DIPNAME( 0xf0, 0x00, DEF_STR( Coinage ) )          PORT_DIPLOCATION("SW1:!5,!6,!7,!8")
	PORT_DIPSETTING(    0x10, "A 2/1 B 2/1" )
	PORT_DIPSETTING(    0x20, "A 2/1 B 1/3" )
	PORT_DIPSETTING(    0x00, "A 1/1 B 1/1" )
	PORT_DIPSETTING(    0x30, "A 1/1 B 1/2" )
	PORT_DIPSETTING(    0x40, "A 1/1 B 1/3" )
	PORT_DIPSETTING(    0x50, "A 1/1 B 1/4" )
	PORT_DIPSETTING(    0x60, "A 1/1 B 1/5" )
	PORT_DIPSETTING(    0x70, "A 1/1 B 1/6" )
	PORT_DIPSETTING(    0x80, "A 1/2 B 1/2" )
	PORT_DIPSETTING(    0x90, "A 1/2 B 1/4" )
	PORT_DIPSETTING(    0xa0, "A 1/2 B 1/5" )
	PORT_DIPSETTING(    0xe0, "A 1/2 B 1/6" )
	PORT_DIPSETTING(    0xb0, "A 1/2 B 1/10" )
	PORT_DIPSETTING(    0xc0, "A 1/2 B 1/11" )
	PORT_DIPSETTING(    0xd0, "A 1/2 B 1/12" )
	PORT_DIPSETTING(    0xf0, DEF_STR( Free_Play ) )

	PORT_START("COM0")
	PORT_BIT( 0x01, IP_ACTIVE_LOW, IPT_UNUSED )
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_START1 )
	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_START2 )
	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_SERVICE1 )  /* IN3 : "AUX-S" */

	PORT_START("COM1")
	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_JOYSTICK_RIGHT ) PORT_8WAY
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_JOYSTICK_LEFT )  PORT_8WAY
	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_JOYSTICK_UP )    PORT_8WAY
	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_JOYSTICK_DOWN )  PORT_8WAY

	PORT_START("COM2")
	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_BUTTON1 )
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN9 */
	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN10 */
	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN11 */

	PORT_START("COM3")
	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_JOYSTICK_RIGHT ) PORT_8WAY PORT_COCKTAIL
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_JOYSTICK_LEFT )  PORT_8WAY PORT_COCKTAIL
	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_JOYSTICK_UP )    PORT_8WAY PORT_COCKTAIL
	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_JOYSTICK_DOWN )  PORT_8WAY PORT_COCKTAIL

	PORT_START("COM4")
	PORT_BIT( 0x01, IP_ACTIVE_HIGH, IPT_BUTTON1 ) PORT_COCKTAIL
	PORT_BIT( 0x02, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN17 */
	PORT_BIT( 0x04, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN18 */
	PORT_BIT( 0x08, IP_ACTIVE_HIGH, IPT_UNKNOWN )   /* IN19 */

	PORT_START("COM5")
	PORT_DIPNAME( 0x01, 0x01, "Coin Counters" )             PORT_DIPLOCATION("SW2:!1")
	PORT_DIPSETTING(    0x01, "1" )
	PORT_DIPSETTING(    0x00, "2" )
	PORT_DIPNAME( 0x02, 0x00, DEF_STR( Demo_Sounds ) )      PORT_DIPLOCATION("SW2:!2")
	PORT_DIPSETTING(    0x02, DEF_STR( Off ) )
	PORT_DIPSETTING(    0x00, DEF_STR( On ) )
	PORT_DIPNAME( 0x0c, 0x0c, DEF_STR( Bonus_Life ) )       PORT_DIPLOCATION("SW2:!3,!4")
	PORT_DIPSETTING(    0x0c, "30k 70k 40k+" )              /* last bonus life at 870k : max. 22 bonus lives */
	PORT_DIPSETTING(    0x04, "20k only" )
	PORT_DIPSETTING(    0x08, "40k only" )
	PORT_DIPSETTING(    0x00, DEF_STR( None ) )
INPUT_PORTS_END

static INPUT_PORTS_START( arabiana )
	PORT_INCLUDE( arabian )

	PORT_MODIFY("COM5")
	PORT_DIPNAME( 0x0c, 0x0c, DEF_STR( Bonus_Life ) )       PORT_DIPLOCATION("SW2:!3,!4")
	PORT_DIPSETTING(    0x0c, "20k 50k 150k 100k+" )        /* last bonus life at 850k : max. 10 bonus lives */
	PORT_DIPSETTING(    0x04, "20k only" )
	PORT_DIPSETTING(    0x08, "40k only" )
	PORT_DIPSETTING(    0x00, DEF_STR( None ) )
INPUT_PORTS_END


/*************************************
 *
 *  Machine driver
 *
 *************************************/

void arabian_state::machine_start()
{
	save_item(NAME(m_mcu_port_o));
	save_item(NAME(m_mcu_port_p));
	save_item(NAME(m_mcu_port_r));
}

void arabian_state::machine_reset()
{
	m_video_control = 0;
}

void arabian_state::arabian(machine_config &config)
{
	/* basic machine hardware */
	Z80(config, m_maincpu, MAIN_OSC/4);
	m_maincpu->set_addrmap(AS_PROGRAM, &arabian_state::main_map);
	m_maincpu->set_addrmap(AS_IO, &arabian_state::main_io_map);
	m_maincpu->set_vblank_int("screen", FUNC(arabian_state::irq0_line_hold));

	MB8841(config, m_mcu, MAIN_OSC/3/2);
	m_mcu->read_k().set(FUNC(arabian_state::mcu_portk_r));
	m_mcu->write_o().set(FUNC(arabian_state::mcu_port_o_w));
	m_mcu->write_p().set(FUNC(arabian_state::mcu_port_p_w));
	m_mcu->read_r<0>().set(FUNC(arabian_state::mcu_port_r0_r));
	m_mcu->write_r<0>().set(FUNC(arabian_state::mcu_port_r0_w));
	m_mcu->read_r<1>().set(FUNC(arabian_state::mcu_port_r1_r));
	m_mcu->write_r<1>().set(FUNC(arabian_state::mcu_port_r1_w));
	m_mcu->read_r<2>().set(FUNC(arabian_state::mcu_port_r2_r));
	m_mcu->write_r<2>().set(FUNC(arabian_state::mcu_port_r2_w));
	m_mcu->read_r<3>().set(FUNC(arabian_state::mcu_port_r3_r));
	m_mcu->write_r<3>().set(FUNC(arabian_state::mcu_port_r3_w));

	config.set_maximum_quantum(attotime::from_hz(6000));

	/* video hardware */
	screen_device &screen(SCREEN(config, "screen", SCREEN_TYPE_RASTER));
	screen.set_refresh_hz(60);
	screen.set_vblank_time(ATTOSECONDS_IN_USEC(0));
	screen.set_size(256, 256);
	screen.set_visarea(0, 255, 11, 244);
	screen.set_screen_update(FUNC(arabian_state::screen_update_arabian));
	screen.set_palette(m_palette);

	PALETTE(config, m_palette, FUNC(arabian_state::arabian_palette), 256 * 32);

	/* sound hardware */
	SPEAKER(config, "mono").front_center();

	ay8910_device &aysnd(AY8910(config, "aysnd", MAIN_OSC/4/2));
	aysnd.port_a_write_callback().set(FUNC(arabian_state::ay8910_porta_w));
	aysnd.port_b_write_callback().set(FUNC(arabian_state::ay8910_portb_w));
	aysnd.add_route(ALL_OUTPUTS, "mono", 0.50);
}



/*************************************
 *
 *  ROM definitions
 *
 *************************************/

ROM_START( arabian )
	ROM_REGION( 0x10000, "maincpu", 0 )
	ROM_LOAD( "ic1rev2.87", 0x0000, 0x2000, CRC(5e1c98b8) SHA1(1775b7b125dde3502aefcf6221662e82f55b3f2a) )
	ROM_LOAD( "ic2rev2.88", 0x2000, 0x2000, CRC(092f587e) SHA1(a722a61d35629ff4087c7a5e4c98b3ab51d6322b) )
	ROM_LOAD( "ic3rev2.89", 0x4000, 0x2000, CRC(15145f23) SHA1(ae250116b57455ed84948cd9a6bdda86b2ac3e16) )
	ROM_LOAD( "ic4rev2.90", 0x6000, 0x2000, CRC(32b77b44) SHA1(9d7951e723bc65e3d607f89836f1436b99f2585b) )

	ROM_REGION( 0x10000, "gfx1", 0 )
	ROM_LOAD( "tvg-91.ic84", 0x0000, 0x2000, CRC(c4637822) SHA1(0c73d9a4db925421a535784780ad93bb0f091051) )
	ROM_LOAD( "tvg-92.ic85", 0x2000, 0x2000, CRC(f7c6866d) SHA1(34f545c5f7c152cd59f7be0a72105f739852cd6a) )
	ROM_LOAD( "tvg-93.ic86", 0x4000, 0x2000, CRC(71acd48d) SHA1(cd0bffed351b14c9aebbfc1d3d4d232a5b91a68f) )
	ROM_LOAD( "tvg-94.ic87", 0x6000, 0x2000, CRC(82160b9a) SHA1(03511f6ebcf22ba709a80a565e71acf5bdecbabb) )

	ROM_REGION( 0x800, "mcu", 0 )
	ROM_LOAD( "sun-8212.ic3", 0x000, 0x800, CRC(8869611e) SHA1(c6443f3bcb0cdb4d7b1b19afcbfe339c300f36aa) )
ROM_END


ROM_START( arabiana )
	ROM_REGION( 0x10000, "maincpu", 0 )
	ROM_LOAD( "tvg-87.ic1", 0x0000, 0x2000, CRC(51e9a6b1) SHA1(a2e6beab5380eed56972f5625be21b01c7e2082a) )
	ROM_LOAD( "tvg-88.ic2", 0x2000, 0x2000, CRC(1cdcc1ab) SHA1(46886d53cc8a1c1d540fd0e1ddf1811fb256c1f3) )
	ROM_LOAD( "tvg-89.ic3", 0x4000, 0x2000, CRC(b7b7faa0) SHA1(719418b7b7c057acb6d3060cf7061ffacf00798c) )
	ROM_LOAD( "tvg-90.ic4", 0x6000, 0x2000, CRC(dbded961) SHA1(ecc09fa95f6dd58c4ac0e095a89ffd3aae681da4) )

	ROM_REGION( 0x10000, "gfx1", 0 )
	ROM_LOAD( "tvg-91.ic84", 0x0000, 0x2000, CRC(c4637822) SHA1(0c73d9a4db925421a535784780ad93bb0f091051) )
	ROM_LOAD( "tvg-92.ic85", 0x2000, 0x2000, CRC(f7c6866d) SHA1(34f545c5f7c152cd59f7be0a72105f739852cd6a) )
	ROM_LOAD( "tvg-93.ic86", 0x4000, 0x2000, CRC(71acd48d) SHA1(cd0bffed351b14c9aebbfc1d3d4d232a5b91a68f) )
	ROM_LOAD( "tvg-94.ic87", 0x6000, 0x2000, CRC(82160b9a) SHA1(03511f6ebcf22ba709a80a565e71acf5bdecbabb) )

	ROM_REGION( 0x800, "mcu", 0 )
	ROM_LOAD( "sun-8212.ic3", 0x000, 0x800, CRC(8869611e) SHA1(c6443f3bcb0cdb4d7b1b19afcbfe339c300f36aa) )
ROM_END



/*************************************
 *
 *  Game drivers
 *
 *************************************/

GAME( 1983, arabian,  0,       arabian, arabian,  arabian_state, empty_init, ROT270, "Sun Electronics",                 "Arabian",         MACHINE_SUPPORTS_SAVE )
GAME( 1983, arabiana, arabian, arabian, arabiana, arabian_state, empty_init, ROT270, "Sun Electronics (Atari license)", "Arabian (Atari)", MACHINE_SUPPORTS_SAVE )

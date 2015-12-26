// license:BSD-3-Clause
// copyright-holders:F. Ulivi
// ********************************************************************************
// * HP "hybrid" processor disassembler
// ********************************************************************************

#include "emu.h"
#include "debugger.h"
#include "hphybrid.h"

typedef void (*fn_dis_param)(char *buffer , offs_t pc , UINT16 opcode , bool is_3001);

typedef struct {
		UINT16 m_op_mask;
		UINT16 m_opcode;
		const char *m_mnemonic;
		fn_dis_param m_param_fn;
		UINT32 m_dasm_flags;
} dis_entry_t;

static void addr_2_str(char *buffer , UINT16 addr , bool indirect , bool is_3001)
{
                char *s = buffer + strlen(buffer);

                s += sprintf(s , "$%04x" , addr);

                if (is_3001) {
                        switch (addr) {
                        case HP_REG_AR1_ADDR:
                                strcpy(s , "(Ar1)");
                                break;

                        case HP_REG_AR1_ADDR + 1:
                                strcpy(s , "(Ar1_2)");
                                break;

                        case HP_REG_AR1_ADDR + 2:
                                strcpy(s , "(Ar1_3)");
                                break;

                        case HP_REG_AR1_ADDR + 3:
                                strcpy(s , "(Ar1_4)");
                                break;

                        case HP_REG_AR2_ADDR:
                                strcpy(s , "(Ar2)");
                                break;

                        case HP_REG_AR2_ADDR + 1:
                                strcpy(s , "(Ar2_2)");
                                break;

                        case HP_REG_AR2_ADDR + 2:
                                strcpy(s , "(Ar2_3)");
                                break;

                        case HP_REG_AR2_ADDR + 3:
                                strcpy(s , "(Ar2_4)");
                                break;

                        case HP_REG_SE_ADDR:
                                strcpy(s , "(SE)");
                                break;

                        case HP_REG_R25_ADDR:
                                strcpy(s , "(R25)");
                                break;

                        case HP_REG_R26_ADDR:
                                strcpy(s , "(R26)");
                                break;

                        case HP_REG_R27_ADDR:
                                strcpy(s , "(R27)");
                                break;

                        case HP_REG_R32_ADDR:
                                strcpy(s , "(R32)");
                                break;

                        case HP_REG_R33_ADDR:
                                strcpy(s , "(R33)");
                                break;

                        case HP_REG_R34_ADDR:
                                strcpy(s , "(R34)");
                                break;

                        case HP_REG_R35_ADDR:
                                strcpy(s , "(R35)");
                                break;

                        case HP_REG_R36_ADDR:
                                strcpy(s , "(R36)");
                                break;

                        case HP_REG_R37_ADDR:
                                strcpy(s , "(R37)");
                                break;
                        }
                }

                switch (addr) {
                case HP_REG_A_ADDR:
                                strcpy(s , "(A)");
                                break;

                case HP_REG_B_ADDR:
                                strcpy(s , "(B)");
                                break;

                case HP_REG_P_ADDR:
                                strcpy(s , "(P)");
                                break;

                case HP_REG_R_ADDR:
                                strcpy(s , "(R)");
                                break;

                case HP_REG_R4_ADDR:
                                strcpy(s , "(R4)");
                                break;

                case HP_REG_R5_ADDR:
                                strcpy(s , "(R5)");
                                break;

                case HP_REG_R6_ADDR:
                                strcpy(s , "(R6)");
                                break;

                case HP_REG_R7_ADDR:
                                strcpy(s , "(R7)");
                                break;

                case HP_REG_IV_ADDR:
                                strcpy(s , "(IV)");
                                break;

                case HP_REG_PA_ADDR:
                                strcpy(s , "(PA)");
                                break;

                case HP_REG_DMAPA_ADDR:
                                strcpy(s , "(DMAPA)");
                                break;

                case HP_REG_DMAMA_ADDR:
                                strcpy(s , "(DMAMA)");
                                break;

                case HP_REG_DMAC_ADDR:
                                strcpy(s , "(DMAC)");
                                break;

                case HP_REG_C_ADDR:
                                strcpy(s , "(C)");
                                break;

                case HP_REG_D_ADDR:
                                strcpy(s , "(D)");
                                break;
                }

                if (indirect) {
                                strcat(s , ",I");
                }
}

static void param_none(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
}

static void param_loc(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		UINT16 base;
		UINT16 off;

		if (opcode & 0x0400) {
				// Current page
				base = pc;
		} else {
				// Base page
				base = 0;
		}

		off = opcode & 0x3ff;
		if (off & 0x200) {
				off -= 0x400;
		}

		addr_2_str(buffer , base + off , (opcode & 0x8000) != 0 , is_3001);
}

static void param_addr32(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		addr_2_str(buffer , opcode & 0x1f , (opcode & 0x8000) != 0 , is_3001);
}

static void param_skip(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		UINT16 off = opcode & 0x3f;
		if (off & 0x20) {
				off -= 0x40;
		}
		addr_2_str(buffer , pc + off , false , is_3001);
}

static void param_skip_sc(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		param_skip(buffer, pc, opcode , is_3001);

		if (opcode & 0x80) {
				if (opcode & 0x40) {
						strcat(buffer , ",S");
				} else {
						strcat(buffer , ",C");
				}
		}
}

static void param_ret(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		char *s = buffer + strlen(buffer);

		int off = opcode & 0x3f;

		if (off & 0x20) {
				off -= 0x40;
		}

		s += sprintf(s , "%d" , off);
		if (opcode & 0x40) {
				strcpy(s , ",P");
		}
}

static void param_n16(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		char *s = buffer + strlen(buffer);

		sprintf(s , "%u" , (opcode & 0xf) + 1);
}

static void param_reg_id(char *buffer , offs_t pc , UINT16 opcode , bool is_3001)
{
		addr_2_str(buffer, opcode & 7, false , is_3001);

		if (opcode & 0x80) {
				strcat(buffer , ",D");
		} else {
				strcat(buffer , ",I");
		}
}

static const dis_entry_t dis_table[] = {
		// *** BPC Instructions ***
		{0xffff , 0x0000 , "NOP" , param_none , 0 },
		{0x7800 , 0x0000 , "LDA" , param_loc , 0 },
		{0x7800 , 0x0800 , "LDB" , param_loc , 0 },
		{0x7800 , 0x1000 , "CPA" , param_loc , 0 },
		{0x7800 , 0x1800 , "CPB" , param_loc , 0 },
		{0x7800 , 0x2000 , "ADA" , param_loc , 0 },
		{0x7800 , 0x2800 , "ADB" , param_loc , 0 },
		{0x7800 , 0x3000 , "STA" , param_loc , 0 },
		{0x7800 , 0x3800 , "STB" , param_loc , 0 },
		{0x7800 , 0x4000 , "JSM" , param_loc , DASMFLAG_STEP_OVER },
		{0x7800 , 0x4800 , "ISZ" , param_loc , 0 },
		{0x7800 , 0x5000 , "AND" , param_loc , 0 },
		{0x7800 , 0x5800 , "DSZ" , param_loc , 0 },
		{0x7800 , 0x6000 , "IOR" , param_loc , 0 },
		{0x7800 , 0x6800 , "JMP" , param_loc , 0 },
		{0x7fe0 , 0x7000 , "EXE" , param_addr32 , 0 },
		{0xffc0 , 0x7400 , "RZA" , param_skip , 0 },
		{0xffc0 , 0x7C00 , "RZB" , param_skip , 0 },
		{0xffc0 , 0x7440 , "RIA" , param_skip , 0 },
		{0xffc0 , 0x7C40 , "RIB" , param_skip , 0 },
		{0xffc0 , 0x7500 , "SZA" , param_skip , 0 },
		{0xffc0 , 0x7D00 , "SZB" , param_skip , 0 },
		{0xffc0 , 0x7540 , "SIA" , param_skip , 0 },
		{0xffc0 , 0x7D40 , "SIB" , param_skip , 0 },
		{0xffc0 , 0x7480 , "SFS" , param_skip , 0 },
		{0xffc0 , 0x7580 , "SFC" , param_skip , 0 },
		{0xffc0 , 0x7c80 , "SSS" , param_skip , 0 },
		{0xffc0 , 0x7d80 , "SSC" , param_skip , 0 },
		{0xffc0 , 0x7cc0 , "SHS" , param_skip , 0 },
		{0xffc0 , 0x7dc0 , "SHC" , param_skip , 0 },
		{0xff00 , 0x7600 , "SLA" , param_skip_sc , 0 },
		{0xff00 , 0x7e00 , "SLB" , param_skip_sc , 0 },
		{0xff00 , 0x7700 , "RLA" , param_skip_sc , 0 },
		{0xff00 , 0x7f00 , "RLB" , param_skip_sc , 0 },
		{0xff00 , 0xf400 , "SAP" , param_skip_sc , 0 },
		{0xff00 , 0xfc00 , "SBP" , param_skip_sc , 0 },
		{0xff00 , 0xf500 , "SAM" , param_skip_sc , 0 },
		{0xff00 , 0xfd00 , "SBM" , param_skip_sc , 0 },
		{0xff00 , 0xf600 , "SOC" , param_skip_sc , 0 },
		{0xff00 , 0xf700 , "SOS" , param_skip_sc , 0 },
		{0xff00 , 0xfe00 , "SEC" , param_skip_sc , 0 },
		{0xff00 , 0xff00 , "SES" , param_skip_sc , 0 },
		{0xffff , 0xf020 , "TCA" , param_none , 0 },
		{0xffff , 0xf820 , "TCB" , param_none , 0 },
		{0xffff , 0xf060 , "CMA" , param_none , 0 },
		{0xffff , 0xf860 , "CMB" , param_none , 0 },
		{0xff80 , 0xf080 , "RET" , param_ret , DASMFLAG_STEP_OUT },
		{0xfff0 , 0xf100 , "AAR" , param_n16 , 0 },
		{0xfff0 , 0xf900 , "ABR" , param_n16 , 0 },
		{0xffff , 0xf14f , "CLA" , param_none , 0 },
		{0xfff0 , 0xf140 , "SAR" , param_n16 , 0 },
		{0xffff , 0xf94f , "CLB" , param_none , 0 },
		{0xfff0 , 0xf940 , "SBR" , param_n16 , 0 },
		{0xfff0 , 0xf180 , "SAL" , param_n16 , 0 },
		{0xfff0 , 0xf980 , "SBL" , param_n16 , 0 },
		{0xfff0 , 0xf1c0 , "RAR" , param_n16 , 0 },
		{0xfff0 , 0xf9c0 , "RBR" , param_n16 , 0 },
		// *** IOC Instructions ***
		{0xffff , 0x7100 , "SDO" , param_none , 0 },
		{0xffff , 0x7108 , "SDI" , param_none , 0 },
		{0xffff , 0x7110 , "EIR" , param_none , 0 },
		{0xffff , 0x7118 , "DIR" , param_none , 0 },
		{0xffff , 0x7120 , "DMA" , param_none , 0 },
		{0xffff , 0x7128 , "PCM" , param_none , 0 },
		{0xffff , 0x7138 , "DDR" , param_none , 0 },
		{0xffff , 0x7140 , "DBL" , param_none , 0 },
		{0xffff , 0x7148 , "CBL" , param_none , 0 },
		{0xffff , 0x7150 , "DBU" , param_none , 0 },
		{0xffff , 0x7158 , "CBU" , param_none , 0 },
		{0xff78 , 0x7160 , "PWC" , param_reg_id , 0 },
		{0xff78 , 0x7168 , "PWD" , param_reg_id , 0 },
		{0xff78 , 0x7960 , "PBC" , param_reg_id , 0 },
		{0xff78 , 0x7968 , "PBD" , param_reg_id , 0 },
		{0xff78 , 0x7170 , "WWC" , param_reg_id , 0 },
		{0xff78 , 0x7178 , "WWD" , param_reg_id , 0 },
		{0xff78 , 0x7970 , "WBC" , param_reg_id , 0 },
		{0xff78 , 0x7978 , "WBD" , param_reg_id , 0 },
		// *** END ***
		{0 , 0 , nullptr , nullptr , 0 }
};

static const dis_entry_t dis_table_emc[] = {
        // *** EMC Instructions ***
        {0xffff , 0x7200 , "MWA" , param_none , 0 },
        {0xffff , 0x7220 , "CMY" , param_none , 0 },
        {0xffff , 0x7260 , "CMX" , param_none , 0 },
        {0xffff , 0x7280 , "FXA" , param_none , 0 },
        {0xfff0 , 0x7300 , "XFR" , param_n16 , 0 },
        {0xffff , 0x7340 , "NRM" , param_none , 0 },
        {0xfff0 , 0x7380 , "CLR" , param_n16 , 0 },
        {0xffff , 0x73c0 , "CDC" , param_none , 0 },
        {0xffc0 , 0x74c0 , "SDS" , param_skip , 0 },
        {0xffc0 , 0x75c0 , "SDC" , param_skip , 0 },
        {0xffff , 0x7a00 , "FMP" , param_none , 0 },
        {0xffff , 0x7a21 , "FDV" , param_none , 0 },
        {0xffff , 0x7b00 , "MRX" , param_none , 0 },
        {0xffff , 0x7b21 , "DRS" , param_none , 0 },
        {0xffff , 0x7b40 , "MRY" , param_none , 0 },
        {0xffff , 0x7b61 , "MLY" , param_none , 0 },
        {0xffff , 0x7b8f , "MPY" , param_none , 0 },
        // *** END ***
        {0 , 0 , nullptr , nullptr , 0 }
};

static offs_t disassemble_table(UINT16 opcode , offs_t pc , const dis_entry_t *table , bool is_3001 , char *buffer)
{
    const dis_entry_t *p;

    for (p = table; p->m_op_mask; p++) {
        if ((opcode & p->m_op_mask) == p->m_opcode) {
            strcpy(buffer , p->m_mnemonic);
            strcat(buffer , " ");
            p->m_param_fn(buffer , pc , opcode , is_3001);
            return 1 | p->m_dasm_flags | DASMFLAG_SUPPORTED;
        }
    }

    return 0;
}

CPU_DISASSEMBLE(hp_hybrid)
{
        UINT16 opcode = ((UINT16)oprom[ 0 ] << 8) | oprom[ 1 ];
        offs_t res;

        res = disassemble_table(opcode , pc , dis_table , false , buffer);

        if (res == 0) {
                // Unknown opcode
                strcpy(buffer , "???");
                res = 1 | DASMFLAG_SUPPORTED;
        }

        return res;
}

CPU_DISASSEMBLE(hp_5061_3001)
{
        UINT16 opcode = ((UINT16)oprom[ 0 ] << 8) | oprom[ 1 ];
        offs_t res;

        res = disassemble_table(opcode , pc , dis_table_emc , true , buffer);

        if (res == 0) {
                res = disassemble_table(opcode , pc , dis_table , true , buffer);
        }

        if (res == 0) {
                // Unknown opcode
                strcpy(buffer , "???");
                res = 1 | DASMFLAG_SUPPORTED;
        }

        return res;
}


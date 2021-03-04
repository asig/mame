// license:BSD-3-Clause
// copyright-holders:Ryan Holtz
//
// Netlist for Atari's Destroyer
//
// Derived from the schematics in the manual.
//
// Known problems/issues:
//    * Sonar sound effect appears to be more noisy than a real cabinet. Unsure, as yet, why.
//

#include "netlist/devices/net_lib.h"

static NETLIST_START(LM324_VM5V12_DIP)
	OPAMP(A, "LM324_M5V12V")
	OPAMP(B, "LM324_M5V12V")
	OPAMP(C, "LM324_M5V12V")
	OPAMP(D, "LM324_M5V12V")

	DIPPINS(        /*   +--------------+   */
		A.OUT,      /*   |1     ++    14|   */ D.OUT,
		A.MINUS,    /*   |2           13|   */ D.MINUS,
		A.PLUS,     /*   |3           12|   */ D.PLUS,
		A.VCC,      /*   |4           11|   */ A.GND,
		B.PLUS,     /*   |5           10|   */ C.PLUS,
		B.MINUS,    /*   |6            9|   */ C.MINUS,
		B.OUT,      /*   |7            8|   */ C.OUT
					/*   +--------------+   */
	)

	NET_C(A.GND, B.GND, C.GND, D.GND)
	NET_C(A.VCC, B.VCC, C.VCC, D.VCC)
NETLIST_END()

NETLIST_START(destroyr)

	SOLVER(Solver, 48000)
	ANALOG_INPUT(V5, 5)
	ANALOG_INPUT(VM5, -5)
	ANALOG_INPUT(V12, 12)
	ALIAS(VCC, V5)
	CLOCK(H256, 15750)
	CLOCK(V8, 984.375)
	NET_C(VCC, H256.VCC, V8.VCC)
	NET_C(GND, H256.GND, V8.GND)

	NET_MODEL("LM324_M5V12V OPAMP(TYPE=3 VLH=1.1 VLL=0.11 FPF=5 UGF=50k SLEW=0.3M RI=1000k RO=50 DAB=0.00075)")

	//LOCAL_SOURCE(NE556_DIP)
	LOCAL_SOURCE(LM324_VM5V12_DIP)

	TTL_INPUT(MOTOR_SPEED, 0)
	TTL_INPUT(NOISE, 0)
	TTL_INPUT(ATTRACT, 0)
	TTL_INPUT(SONGATE, 0)
	TTL_INPUT(LAUNCH, 0)
	TTL_INPUT(EXPLO, 0)
	TTL_INPUT(SONLAT, 0)
	TTL_INPUT(HE, 0)
	TTL_INPUT(LE, 0)
	NET_C(VCC, MOTOR_SPEED.VCC, NOISE.VCC, ATTRACT.VCC, SONGATE.VCC, LAUNCH.VCC, EXPLO.VCC, SONLAT.VCC, HE.VCC, LE.VCC)
	NET_C(GND, MOTOR_SPEED.GND, NOISE.GND, ATTRACT.GND, SONGATE.GND, LAUNCH.GND, EXPLO.GND, SONLAT.GND, HE.GND, LE.GND)

	RES(R39, 220)
	RES(R40, 220)
	RES(R41, RES_K(2.2))
	RES(R42, RES_K(39))
	RES(R43, RES_K(150))
	RES(R44, 820)
	RES(R54, RES_K(10))
	RES(R59, RES_K(470))
	RES(R60, RES_K(470))
	RES(R61, RES_K(10))
	RES(R62, RES_K(10))
	RES(R63, RES_M(10))
	RES(R64, RES_K(100))
	RES(R65, RES_K(100))
	RES(R66, RES_K(100))
	RES(R67, RES_K(10))
	RES(R68, RES_K(10))
	RES(R69, RES_K(10))
	RES(R70, RES_K(3.3))
	RES(R71, RES_K(15))
	RES(R72, RES_K(33))
	RES(R73, RES_K(10))
	RES(R74, RES_K(100))
	RES(R75, RES_K(33))
	RES(R76, RES_K(22))
	RES(R77, RES_K(47))
	RES(R78, RES_K(5.6))
	RES(R79, RES_K(33))
	RES(R80, RES_K(3.9))
	RES(R81, RES_K(3.9))
	RES(R82, RES_K(2.2))
	RES(R83, RES_K(330))
	RES(R86, 680)
	RES(R88, RES_K(2.7))
	RES(R89, RES_K(10))
	RES(R92, RES_K(2.2))
	RES(R93, RES_K(2.2))
	RES(R94, RES_K(68))
	POT(R95, RES_K(50))

	CAP(C38, CAP_U(10))
	CAP(C39, CAP_U(0.1))
	CAP(C40, CAP_U(0.1))
	CAP(C48, CAP_U(10))
	CAP(C49, CAP_P(330))
	CAP(C51, CAP_P(330))
	CAP(C52, CAP_U(0.1))
	CAP(C53, CAP_U(10))
	CAP(C56, CAP_U(0.22))
	CAP(C57, CAP_U(0.22))
	CAP(C58, CAP_U(0.22))
	CAP(C59, CAP_U(0.1))
	CAP(C61, CAP_U(0.22))
	CAP(C62, CAP_U(0.022))
	CAP(C63, CAP_U(22))
	CAP(C64, CAP_U(0.022))
	CAP(C66, CAP_U(10))
	CAP(C71, CAP_U(0.1))
	CAP(C72, CAP_U(0.1))
	CAP(C74, CAP_U(0.22))
	//CAP(C81, CAP_U(0.1))
	CAP(C85, CAP_U(22))

	DIODE(CR2, "1N914")

	QBJT_EB(Q4, "2N3643")
	QBJT_EB(Q6, "2N3643")

	TTL_7486_DIP(IC_L7)
	TTL_74164_DIP(IC_L9)
	TTL_74164_DIP(IC_M9)
	TTL_7402_DIP(IC_K8) // Should be a 7428 positive-NOR gate
	TTL_7432_DIP(IC_M8)
	TTL_7400_DIP(IC_A9)
	TTL_7404_DIP(IC_K9)
	NET_C(VCC, IC_L9.14, IC_M9.14, IC_L7.14, IC_K8.14, IC_M8.14, IC_K9.14, IC_A9.14)
	NET_C(GND, IC_L9.7,  IC_M9.7,  IC_L7.7,  IC_K8.7,  IC_M8.7,  IC_K9.7,  IC_A9.7)

	SUBMODEL(NE556_DIP, IC_H8)
	NET_C(VCC, IC_H8.14)
	NET_C(GND, IC_H8.7)

	MC3340_DIP(IC_D10)
	NET_C(VCC, IC_D10.8)
	NET_C(VM5, IC_D10.3)

	CD4066_DIP(IC_E9)
	NET_C(VCC, IC_E9.14)
	NET_C(GND, IC_E9.7)

	SUBMODEL(LM324_VM5V12_DIP, IC_C9)
	SUBMODEL(LM324_VM5V12_DIP, IC_H9)
	NET_C(V12, IC_C9.4,  IC_H9.4)
	NET_C(VM5, IC_C9.11, IC_H9.11)

	// Tie off unused gates and pins
	NET_C(GND, IC_L7.1,  IC_L7.2)
	NET_C(GND, IC_L7.4,  IC_L7.5)
	NET_C(GND, IC_L7.9,  IC_L7.10)
	NET_C(GND, IC_M8.4,  IC_M8.5)
	NET_C(GND, IC_M8.9,  IC_M8.10)
	NET_C(GND, IC_M8.12, IC_M8.13)
	NET_C(GND, IC_A9.1,  IC_A9.2)
	NET_C(GND, IC_A9.9,  IC_A9.10)
	NET_C(GND, IC_A9.12, IC_A9.13)
	NET_C(GND, IC_K9.1,  IC_K9.5, IC_K9.9, IC_K9.11, IC_K9.13)
	NET_C(GND, IC_H8.5,  IC_H8.9)
	NET_C(VCC, IC_H8.4,  IC_H8.10)

	// Noise Clock
	NET_C(H256.Q, IC_K8.2)
	NET_C(EXPLO.Q, IC_K8.3)
	NET_C(V8.Q, IC_K8.5)
	NET_C(SONLAT.Q, IC_K8.6)
	NET_C(IC_K8.1, IC_M8.1)
	NET_C(IC_K8.4, IC_M8.2)
	ALIAS(NOISECLK, IC_M8.3)

	// Noise
	NET_C(NOISE.Q, IC_L9.9, IC_M9.9)
	NET_C(NOISECLK, IC_L9.8, IC_M9.8)
	NET_C(IC_M9.12, IC_K9.3)
	NET_C(IC_K9.4, IC_L7.13)
	NET_C(IC_M9.11, IC_L7.12)
	ALIAS(RNOISE, IC_M9.11)
	NET_C(IC_L7.11, IC_L9.1, IC_L9.2)
	NET_C(IC_L9.13, IC_M9.1, IC_M9.2)

	// Explosions
	NET_C(SONLAT.Q, IC_K8.9)
	NET_C(EXPLO.Q, IC_K8.8)
	NET_C(IC_K8.10, CR2.A, R39.2, IC_K8.11)
	NET_C(RNOISE, IC_K8.12)
	NET_C(V5, R39.1, R68.1)
	NET_C(IC_K8.13, IC_E9.5)
	NET_C(CR2.K, C38.1, IC_E9.4)
	NET_C(GND, C38.2, R70.2, R61.2, C48.2, R73.2, R86.2, C53.2, R67.2, Q6.E, Q4.E, C85.2)
	NET_C(IC_E9.3, R74.1, IC_E9.11, R71.1)
	NET_C(LE.Q, IC_E9.13)
	NET_C(HE.Q, IC_E9.12)
	NET_C(R71.2, C52.1, R70.1)
	NET_C(C52.2, R66.1)
	NET_C(R66.2, IC_H9.10, R63.1)
	NET_C(IC_H9.9, R64.1, R65.1)
	NET_C(IC_H9.8, R64.2, R60.1)
	NET_C(R60.2, C49.1, IC_H9.6)
	NET_C(C49.2, IC_H9.7, R59.1, R63.2, R72.1)
	NET_C(IC_H9.5, IC_H9.3, R62.2, R61.1, C48.1)
	NET_C(V12, R62.1)
	NET_C(R59.2, C51.1, IC_H9.2)
	NET_C(IC_H9.1, C51.2, R65.2)
	NET_C(SONGATE.Q, IC_E9.6)
	NET_C(R72.2, R73.1, IC_E9.8, R82.1)
	NET_C(R74.2, R86.1, C71.1, C72.1)
	NET_C(R68.2, R67.1, C53.1, IC_H9.12, IC_C9.3)
	NET_C(C71.2, R83.1, IC_H9.13)
	NET_C(C72.2, R83.2, IC_H9.14, R69.1)
	NET_C(R69.2, IC_E9.1)
	NET_C(IC_E9.2, R79.1, IC_C9.2)
	NET_C(IC_C9.1, R79.2, C61.1)
	NET_C(C61.2, R78.1)
	NET_C(IC_E9.10, C57.1)
	NET_C(C57.2, R77.1)
	NET_C(IC_E9.9, C56.1)
	NET_C(C56.2, R76.1)

	// Launch
	NET_C(RNOISE, IC_A9.4)
	NET_C(LAUNCH.Q, IC_A9.5)
	NET_C(IC_A9.6, R81.1)
	NET_C(R81.2, C64.1)
	NET_C(C64.2, IC_C9.9, R80.1, C62.1)
	NET_C(C62.2, R80.2, IC_C9.8, C58.1)
	NET_C(GND, IC_C9.10)
	NET_C(C58.2, R75.1)

	// Motor
	NET_C(MOTOR_SPEED.Q, R44.1)
	NET_C(R44.2, R40.2, IC_H8.3, IC_H8.11, C63.1)
	NET_C(V5, R40.1, R41.1, R54.1, R89.1)
	NET_C(R41.2, R42.1, IC_H8.1)
	NET_C(R42.2, IC_H8.2, IC_H8.6, C39.1, IC_C9.5)
	NET_C(R54.2, R43.1, IC_H8.13)
	NET_C(R43.2, IC_H8.8, IC_H8.12, C40.1, IC_C9.12)
	NET_C(C63.2, IC_C9.13, IC_C9.14, C66.2)
	NET_C(GND, C39.2, C40.2)
	NET_C(IC_C9.6, IC_C9.7, C59.2)
	NET_C(C59.1, IC_D10.1)
	NET_C(C66.1, R88.2, R89.2, IC_D10.2)
	NET_C(VM5, R88.1)
	NET_C(IC_D10.6, Q4.C)
	NET_C(IC_D10.7, C74.1)
	NET_C(C74.2, R94.1)

	// Attract Mute
	NET_C(ATTRACT.Q, R92.1, R93.1)
	NET_C(R92.2, C85.1, Q4.B)
	NET_C(R93.2, Q6.B)
	NET_C(Q6.C, R82.2)

	// Mixer
	NET_C(GND, R95.1)
	NET_C(R94.2, R75.2, R76.2, R77.2, R78.2, R95.3)
	ALIAS(OUTPUT, R95.2)

	// Unconnected pins
	HINT(IC_A9.3, NC)
	HINT(IC_A9.8, NC)
	HINT(IC_A9.11, NC)
	HINT(IC_K9.2, NC)
	HINT(IC_K9.6, NC)
	HINT(IC_K9.8, NC)
	HINT(IC_K9.10, NC)
	HINT(IC_K9.12, NC)
	HINT(IC_L9.3, NC)
	HINT(IC_L9.4, NC)
	HINT(IC_L9.5, NC)
	HINT(IC_L9.6, NC)
	HINT(IC_L9.10, NC)
	HINT(IC_L9.11, NC)
	HINT(IC_L9.12, NC)
	HINT(IC_M9.3, NC)
	HINT(IC_M9.4, NC)
	HINT(IC_M9.5, NC)
	HINT(IC_M9.6, NC)
	HINT(IC_M9.10, NC)
	HINT(IC_M9.13, NC)
	HINT(IC_L7.3, NC)
	HINT(IC_L7.6, NC)
	HINT(IC_L7.8, NC)
	HINT(IC_M8.6, NC)
	HINT(IC_M8.8, NC)
	HINT(IC_M8.11, NC)
NETLIST_END()

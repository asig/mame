-- license:BSD-3-Clause
-- copyright-holders:MAMEdev Team

---------------------------------------------------------------------------
--
--   3rdparty.lua
--
--   Library objects for all 3rdparty sources
--
---------------------------------------------------------------------------

--------------------------------------------------
-- expat library objects
--------------------------------------------------

if not _OPTIONS["with-system-expat"] then
project "expat"
	uuid "f4cd40b1-c37c-452d-9785-640f26f0bf54"
	kind "StaticLib"

	-- fake out the enough of expat_config.h to get by
	defines {
		"HAVE_MEMMOVE",
		"HAVE_STDINT_H",
		"HAVE_STDLIB_H",
		"HAVE_STRING_H",
		"PACKAGE_BUGREPORT=\"expat-bugs@libexpat.org\"",
		"PACKAGE_NAME=\"expat\"",
		"PACKAGE_STRING=\"expat 2.1.1\"",
		"PACKAGE_TARNAME=\"expat\"",
		"PACKAGE_URL=\"\"",
		"PACKAGE_VERSION=\"2.1.1\"",
		"STDC_HEADERS",
		"XML_CONTEXT_BYTES=1024",
		"XML_DTD",
		"XML_NS",
	}
if _OPTIONS["BIGENDIAN"]=="1" then
	defines {
		"BYTEORDER=4321",
		"WORDS_BIGENDIAN",
	}
else
	defines {
		"BYTEORDER=1234",
	}
end

	configuration { "vs*" }
		buildoptions {
			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd111",              -- remark #111: statement is unreachable
			"/Qwd1879",             -- warning #1879: unimplemented pragma ignored
			"/Qwd2557",             -- remark #2557: comparison between signed and unsigned operands
			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
		}
end
	configuration { "vs2015" }
		buildoptions {
			"/wd4456", -- warning C4456: declaration of 'xxx' hides previous local declaration
		}
	configuration { }

	files {
		MAME_DIR .. "3rdparty/expat/lib/xmlparse.c",
		MAME_DIR .. "3rdparty/expat/lib/xmlrole.c",
		MAME_DIR .. "3rdparty/expat/lib/xmltok.c",
	}
else
links {
	ext_lib("expat"),
}
end

--------------------------------------------------
-- zlib library objects
--------------------------------------------------

if not _OPTIONS["with-system-zlib"] then
project "zlib"
	uuid "3d78bd2a-2bd0-4449-8087-42ddfaef7ec9"
	kind "StaticLib"

	local version = str_to_version(_OPTIONS["gcc_version"])
	if _OPTIONS["gcc"]~=nil and ((string.find(_OPTIONS["gcc"], "clang") or string.find(_OPTIONS["gcc"], "asmjs") or string.find(_OPTIONS["gcc"], "android"))) then
		configuration { "gmake" }
		if (version >= 30700) then
			buildoptions {
				"-Wno-shift-negative-value",
			}
		end
	end

	configuration { "vs*" }
		buildoptions {
			"/wd4131", -- warning C4131: 'xxx' : uses old-style declarator
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd111",              -- remark #111: statement is unreachable
			"/Qwd280",              -- remark #280: selector expression is constant
		}
end
	configuration "Debug"
		defines {
			"verbose=-1",
		}

	configuration { "gmake" }
		buildoptions_c {
			"-Wno-strict-prototypes",
		}

	configuration { }
		defines {
			"ZLIB_CONST",
		}

	files {
		MAME_DIR .. "3rdparty/zlib/adler32.c",
		MAME_DIR .. "3rdparty/zlib/compress.c",
		MAME_DIR .. "3rdparty/zlib/crc32.c",
		MAME_DIR .. "3rdparty/zlib/deflate.c",
		MAME_DIR .. "3rdparty/zlib/inffast.c",
		MAME_DIR .. "3rdparty/zlib/inflate.c",
		MAME_DIR .. "3rdparty/zlib/infback.c",
		MAME_DIR .. "3rdparty/zlib/inftrees.c",
		MAME_DIR .. "3rdparty/zlib/trees.c",
		MAME_DIR .. "3rdparty/zlib/uncompr.c",
		MAME_DIR .. "3rdparty/zlib/zutil.c",
	}
else
links {
	ext_lib("zlib"),
}
end

--------------------------------------------------
-- SoftFloat library objects
--------------------------------------------------

project "softfloat"
	uuid "04fbf89e-4761-4cf2-8a12-64500cf0c5c5"
	kind "StaticLib"

	options {
		"ForceCPP",
	}

	includedirs {
		MAME_DIR .. "src/osd",
	}
	configuration { "vs*" }
		buildoptions {
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4146", -- warning C4146: unary minus operator applied to unsigned type, result still unsigned
			"/wd4018", -- warning C4018: 'x' : signed/unsigned mismatch
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd2557",             -- remark #2557: comparison between signed and unsigned operands
		}
end
	configuration { }

	files {
		MAME_DIR .. "3rdparty/softfloat/softfloat.c",
		MAME_DIR .. "3rdparty/softfloat/fsincos.c",
		MAME_DIR .. "3rdparty/softfloat/fyl2x.c",
	}

--------------------------------------------------
-- libJPEG library objects
--------------------------------------------------

if not _OPTIONS["with-system-jpeg"] then
project "jpeg"
	uuid "447c6800-dcfd-4c48-b72a-a8223bb409ca"
	kind "StaticLib"

	configuration { "vs*" }
		buildoptions {
			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
		}
end

	configuration { }

	files {
		MAME_DIR .. "3rdparty/libjpeg/jaricom.c",
		MAME_DIR .. "3rdparty/libjpeg/jcapimin.c",
		MAME_DIR .. "3rdparty/libjpeg/jcapistd.c",
		MAME_DIR .. "3rdparty/libjpeg/jcarith.c",
		MAME_DIR .. "3rdparty/libjpeg/jccoefct.c",
		MAME_DIR .. "3rdparty/libjpeg/jccolor.c",
		MAME_DIR .. "3rdparty/libjpeg/jcdctmgr.c",
		MAME_DIR .. "3rdparty/libjpeg/jchuff.c",
		MAME_DIR .. "3rdparty/libjpeg/jcinit.c",
		MAME_DIR .. "3rdparty/libjpeg/jcmainct.c",
		MAME_DIR .. "3rdparty/libjpeg/jcmarker.c",
		MAME_DIR .. "3rdparty/libjpeg/jcmaster.c",
		MAME_DIR .. "3rdparty/libjpeg/jcomapi.c",
		MAME_DIR .. "3rdparty/libjpeg/jcparam.c",
		MAME_DIR .. "3rdparty/libjpeg/jcprepct.c",
		MAME_DIR .. "3rdparty/libjpeg/jcsample.c",
		MAME_DIR .. "3rdparty/libjpeg/jctrans.c",
		MAME_DIR .. "3rdparty/libjpeg/jdapimin.c",
		MAME_DIR .. "3rdparty/libjpeg/jdapistd.c",
		MAME_DIR .. "3rdparty/libjpeg/jdarith.c",
		MAME_DIR .. "3rdparty/libjpeg/jdatadst.c",
		MAME_DIR .. "3rdparty/libjpeg/jdatasrc.c",
		MAME_DIR .. "3rdparty/libjpeg/jdcoefct.c",
		MAME_DIR .. "3rdparty/libjpeg/jdcolor.c",
		MAME_DIR .. "3rdparty/libjpeg/jddctmgr.c",
		MAME_DIR .. "3rdparty/libjpeg/jdhuff.c",
		MAME_DIR .. "3rdparty/libjpeg/jdinput.c",
		MAME_DIR .. "3rdparty/libjpeg/jdmainct.c",
		MAME_DIR .. "3rdparty/libjpeg/jdmarker.c",
		MAME_DIR .. "3rdparty/libjpeg/jdmaster.c",
		MAME_DIR .. "3rdparty/libjpeg/jdmerge.c",
		MAME_DIR .. "3rdparty/libjpeg/jdpostct.c",
		MAME_DIR .. "3rdparty/libjpeg/jdsample.c",
		MAME_DIR .. "3rdparty/libjpeg/jdtrans.c",
		MAME_DIR .. "3rdparty/libjpeg/jerror.c",
		MAME_DIR .. "3rdparty/libjpeg/jfdctflt.c",
		MAME_DIR .. "3rdparty/libjpeg/jfdctfst.c",
		MAME_DIR .. "3rdparty/libjpeg/jfdctint.c",
		MAME_DIR .. "3rdparty/libjpeg/jidctflt.c",
		MAME_DIR .. "3rdparty/libjpeg/jidctfst.c",
		MAME_DIR .. "3rdparty/libjpeg/jidctint.c",
		MAME_DIR .. "3rdparty/libjpeg/jquant1.c",
		MAME_DIR .. "3rdparty/libjpeg/jquant2.c",
		MAME_DIR .. "3rdparty/libjpeg/jutils.c",
		MAME_DIR .. "3rdparty/libjpeg/jmemmgr.c",
		MAME_DIR .. "3rdparty/libjpeg/jmemansi.c",
	}
else
links {
	ext_lib("jpeg"),
}
end

--------------------------------------------------
-- libflac library objects
--------------------------------------------------

if not _OPTIONS["with-system-flac"] then
project "flac"
	uuid "b6fc19e8-073a-4541-bb7b-d24b548d424a"
	kind "StaticLib"

	configuration { "vs*" }
		buildoptions {
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
			"/wd4702", -- warning C4702: unreachable code
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd111",              -- remark #111: statement is unreachable
			"/Qwd177",              -- remark #177: function "xxx" was declared but never referenced
			"/Qwd181",              -- remark #181: argument of type "UINT32={unsigned int}" is incompatible with format "%d", expecting argument of type "int"
			"/Qwd188",              -- error #188: enumerated type mixed with another type
			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
		}
end

	configuration { "mingw-clang" }
		buildoptions {
			"-include stdint.h"
		}

	configuration { "vs2015" }
		buildoptions {
			"/wd4456", -- warning C4456: declaration of 'xxx' hides previous local declaration
		}

	configuration { }
		defines {
			"WORDS_BIGENDIAN=0",
			"FLAC__NO_ASM",
			"_LARGEFILE_SOURCE",
			"_FILE_OFFSET_BITS=64",
			"FLAC__HAS_OGG=0",
			"HAVE_CONFIG_H=1",
		}

	configuration { "gmake" }
		buildoptions_c {
			"-Wno-unused-function",
			"-O0",
		}
	if _OPTIONS["gcc"]~=nil and (string.find(_OPTIONS["gcc"], "clang") or string.find(_OPTIONS["gcc"], "android")) then
		buildoptions {
			"-Wno-enum-conversion",
		}
		if _OPTIONS["targetos"]=="macosx" then
			buildoptions_c {
				"-Wno-unknown-attributes",
			}
		end
	end
	configuration { }

	includedirs {
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/include",
		MAME_DIR .. "3rdparty/libflac/include",
	}

	files {
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/bitmath.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/bitreader.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/bitwriter.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/cpu.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/crc.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/fixed.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/float.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/format.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/lpc.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/md5.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/memory.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/stream_decoder.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/stream_encoder.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/stream_encoder_framing.c",
		MAME_DIR .. "3rdparty/libflac/src/libFLAC/window.c",
	}
else
links {
	ext_lib("flac"),
}
end

--------------------------------------------------
-- lib7z library objects
--------------------------------------------------

project "7z"
	uuid "ad573d62-e76a-4b11-ae34-5110a6789a42"
	kind "StaticLib"

	configuration { "gmake" }
		buildoptions_c {
			"-Wno-undef",
      "-Wno-strict-prototypes",
		}

	configuration { "mingw*" }
		buildoptions_c {
			"-Wno-strict-prototypes",
		}
		
	configuration { "vs*" }
		buildoptions {
			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
		}
end
	configuration { "vs2015" }
		buildoptions {
			"/wd4456", -- warning C4456: declaration of 'xxx' hides previous local declaration
			"/wd4457", -- warning C4457: declaration of 'xxx' hides function parameter
		}

	configuration { }
		defines {
			"_7ZIP_PPMD_SUPPPORT",
			"_7ZIP_ST",
		}

	files {
			MAME_DIR .. "3rdparty/lzma/C/7zAlloc.c",
			MAME_DIR .. "3rdparty/lzma/C/7zArcIn.c",
			MAME_DIR .. "3rdparty/lzma/C/7zBuf.c",
			MAME_DIR .. "3rdparty/lzma/C/7zBuf2.c",
			MAME_DIR .. "3rdparty/lzma/C/7zCrc.c",
			MAME_DIR .. "3rdparty/lzma/C/7zCrcOpt.c",
			MAME_DIR .. "3rdparty/lzma/C/7zDec.c",
			MAME_DIR .. "3rdparty/lzma/C/7zFile.c",
			MAME_DIR .. "3rdparty/lzma/C/7zStream.c",
			MAME_DIR .. "3rdparty/lzma/C/Aes.c",
			MAME_DIR .. "3rdparty/lzma/C/AesOpt.c",
			MAME_DIR .. "3rdparty/lzma/C/Alloc.c",
			MAME_DIR .. "3rdparty/lzma/C/Bcj2.c",
			-- MAME_DIR .. "3rdparty/lzma/C/Bcj2Enc.c",
			MAME_DIR .. "3rdparty/lzma/C/Bra.c",
			MAME_DIR .. "3rdparty/lzma/C/Bra86.c",
			MAME_DIR .. "3rdparty/lzma/C/BraIA64.c",
			MAME_DIR .. "3rdparty/lzma/C/CpuArch.c",
			MAME_DIR .. "3rdparty/lzma/C/Delta.c",
			MAME_DIR .. "3rdparty/lzma/C/LzFind.c",
			-- MAME_DIR .. "3rdparty/lzma/C/LzFindMt.c",
			MAME_DIR .. "3rdparty/lzma/C/Lzma2Dec.c",
			MAME_DIR .. "3rdparty/lzma/C/Lzma2Enc.c",
			MAME_DIR .. "3rdparty/lzma/C/Lzma86Dec.c",
			MAME_DIR .. "3rdparty/lzma/C/Lzma86Enc.c",
			MAME_DIR .. "3rdparty/lzma/C/LzmaDec.c",
			MAME_DIR .. "3rdparty/lzma/C/LzmaEnc.c",
			-- MAME_DIR .. "3rdparty/lzma/C/LzmaLib.c",
			-- MAME_DIR .. "3rdparty/lzma/C/MtCoder.c",
			MAME_DIR .. "3rdparty/lzma/C/Ppmd7.c",
			MAME_DIR .. "3rdparty/lzma/C/Ppmd7Dec.c",
			MAME_DIR .. "3rdparty/lzma/C/Ppmd7Enc.c",
			MAME_DIR .. "3rdparty/lzma/C/Sha256.c",
			MAME_DIR .. "3rdparty/lzma/C/Sort.c",
			-- MAME_DIR .. "3rdparty/lzma/C/Threads.c",
			-- MAME_DIR .. "3rdparty/lzma/C/Xz.c",
			-- MAME_DIR .. "3rdparty/lzma/C/XzCrc64.c",
			-- MAME_DIR .. "3rdparty/lzma/C/XzCrc64Opt.c",
			-- MAME_DIR .. "3rdparty/lzma/C/XzDec.c",
			-- MAME_DIR .. "3rdparty/lzma/C/XzEnc.c",
			-- MAME_DIR .. "3rdparty/lzma/C/XzIn.c",
		}

--------------------------------------------------
-- LUA library objects
--------------------------------------------------

if not _OPTIONS["with-system-lua"] then
project "lua"
	uuid "d9e2eed1-f1ab-4737-a6ac-863700b1a5a9"
	kind "StaticLib"

	-- uncomment the options below to
	-- compile using c++. Do the same
	-- in lualibs.
	-- In addition comment out the "extern "C""
	-- in lua.hpp and do the same in luaengine.c line 47
	--options {
	--  "ForceCPP",
	--}

	configuration { "gmake" }
		buildoptions_c {
			"-Wno-bad-function-cast"
		}

	configuration { "vs*" }
		buildoptions {
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4702", -- warning C4702: unreachable code
			"/wd4310", -- warning C4310: cast truncates constant value
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd592", -- error #592: variable "xxx" is used before its value is set
		}
end
	configuration { }
		defines {
			"LUA_COMPAT_ALL",
			"LUA_COMPAT_5_1",
			"LUA_COMPAT_5_2",
		}
	if not (_OPTIONS["targetos"]=="windows") and not (_OPTIONS["targetos"]=="asmjs") and not (_OPTIONS["targetos"]=="pnacl") then
		defines {
			"LUA_USE_POSIX",
		}
	end
	if ("pnacl" == _OPTIONS["gcc"]) then
		defines {
			"LUA_32BITS",
		}
	end

	configuration { }

	includedirs {
		MAME_DIR .. "3rdparty",
	}

	files {
		MAME_DIR .. "3rdparty/lua/src/lapi.c",
		MAME_DIR .. "3rdparty/lua/src/lcode.c",
		MAME_DIR .. "3rdparty/lua/src/lctype.c",
		MAME_DIR .. "3rdparty/lua/src/ldebug.c",
		MAME_DIR .. "3rdparty/lua/src/ldo.c",
		MAME_DIR .. "3rdparty/lua/src/ldump.c",
		MAME_DIR .. "3rdparty/lua/src/lfunc.c",
		MAME_DIR .. "3rdparty/lua/src/lgc.c",
		MAME_DIR .. "3rdparty/lua/src/llex.c",
		MAME_DIR .. "3rdparty/lua/src/lmem.c",
		MAME_DIR .. "3rdparty/lua/src/lobject.c",
		MAME_DIR .. "3rdparty/lua/src/lopcodes.c",
		MAME_DIR .. "3rdparty/lua/src/lparser.c",
		MAME_DIR .. "3rdparty/lua/src/lstate.c",
		MAME_DIR .. "3rdparty/lua/src/lstring.c",
		MAME_DIR .. "3rdparty/lua/src/ltable.c",
		MAME_DIR .. "3rdparty/lua/src/ltm.c",
		MAME_DIR .. "3rdparty/lua/src/lundump.c",
		MAME_DIR .. "3rdparty/lua/src/lvm.c",
		MAME_DIR .. "3rdparty/lua/src/lzio.c",
		MAME_DIR .. "3rdparty/lua/src/lauxlib.c",
		MAME_DIR .. "3rdparty/lua/src/lbaselib.c",
		MAME_DIR .. "3rdparty/lua/src/lbitlib.c",
		MAME_DIR .. "3rdparty/lua/src/lcorolib.c",
		MAME_DIR .. "3rdparty/lua/src/ldblib.c",
		MAME_DIR .. "3rdparty/lua/src/liolib.c",
		MAME_DIR .. "3rdparty/lua/src/lmathlib.c",
		MAME_DIR .. "3rdparty/lua/src/loslib.c",
		MAME_DIR .. "3rdparty/lua/src/lstrlib.c",
		MAME_DIR .. "3rdparty/lua/src/ltablib.c",
		MAME_DIR .. "3rdparty/lua/src/loadlib.c",
		MAME_DIR .. "3rdparty/lua/src/linit.c",
		MAME_DIR .. "3rdparty/lua/src/lutf8lib.c",
	}
else
links {
	ext_lib("lua"),
}
end

--------------------------------------------------
-- small lua library objects
--------------------------------------------------

project "lualibs"
	uuid "1d84edab-94cf-48fb-83ee-b75bc697660e"
	kind "StaticLib"

	configuration { "vs*" }
		buildoptions {
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4055", -- warning C4055: 'type cast': from data pointer 'void *' to function pointer 'xxx'
			"/wd4152", -- warning C4152: nonstandard extension, function/data pointer conversion in expression
			"/wd4130", -- warning C4130: '==': logical operation on address of string constant
		}

	configuration { "pnacl"}
		buildoptions {
			"-Wno-char-subscripts",
		}

	configuration { }
		defines {
			"LUA_COMPAT_ALL",
		}

	includedirs {
		MAME_DIR .. "3rdparty",
	}
	includedirs {
		ext_includedir("lua"),
		ext_includedir("zlib"),
	}

	files {
		MAME_DIR .. "3rdparty/lua-zlib/lua_zlib.c",
		MAME_DIR .. "3rdparty/luafilesystem/src/lfs.c",
	}

--------------------------------------------------
-- portmidi library objects
--------------------------------------------------
if _OPTIONS["NO_USE_MIDI"]~="1" then
if not _OPTIONS["with-system-portmidi"] then
project "portmidi"
	uuid "587f2da6-3274-4a65-86a2-f13ea315bb98"
	kind "StaticLib"

	includedirs {
		MAME_DIR .. "3rdparty/portmidi/pm_common",
		MAME_DIR .. "3rdparty/portmidi/porttime",
	}

	configuration { "vs*" }
		buildoptions {
			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
			"/wd4127", -- warning C4127: conditional expression is constant
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4706", -- warning C4706: assignment within conditional expression
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd188",              -- error #188: enumerated type mixed with another type
			"/Qwd344",              -- remark #344: typedef name has already been declared (with same type)
			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
			"/Qwd2557",             -- remark #2557: comparison between signed and unsigned operands
		}
end

	configuration { "vs2015" }
		buildoptions {
			"/wd4456", -- warning C4456: declaration of 'xxx' hides previous local declaration
		}

	configuration { "linux*" }
		defines {
			"PMALSA=1",
		}

	configuration { }

	files {
		MAME_DIR .. "3rdparty/portmidi/pm_common/portmidi.c",
		MAME_DIR .. "3rdparty/portmidi/pm_common/pmutil.c",
	}

	if _OPTIONS["targetos"]=="windows" then
		files {
			MAME_DIR .. "3rdparty/portmidi/porttime/ptwinmm.c",
			MAME_DIR .. "3rdparty/portmidi/pm_win/pmwin.c",
			MAME_DIR .. "3rdparty/portmidi/pm_win/pmwinmm.c",
			MAME_DIR .. "3rdparty/portmidi/porttime/ptwinmm.c",
		}
	end

	if _OPTIONS["targetos"]=="linux" then
		files {
			MAME_DIR .. "3rdparty/portmidi/pm_linux/pmlinux.c",
			MAME_DIR .. "3rdparty/portmidi/pm_linux/pmlinuxalsa.c",
			MAME_DIR .. "3rdparty/portmidi/pm_linux/finddefault.c",
			MAME_DIR .. "3rdparty/portmidi/porttime/ptlinux.c",
		}
	end
	if _OPTIONS["targetos"]=="netbsd" then
		files {
			MAME_DIR .. "3rdparty/portmidi/pm_linux/pmlinux.c",
			MAME_DIR .. "3rdparty/portmidi/pm_linux/finddefault.c",
			MAME_DIR .. "3rdparty/portmidi/porttime/ptlinux.c",
		}
	end
	if _OPTIONS["targetos"]=="macosx" then
		files {
			MAME_DIR .. "3rdparty/portmidi/pm_mac/pmmac.c",
			MAME_DIR .. "3rdparty/portmidi/pm_mac/pmmacosxcm.c",
			MAME_DIR .. "3rdparty/portmidi/pm_mac/finddefault.c",
			MAME_DIR .. "3rdparty/portmidi/pm_mac/readbinaryplist.c",
			MAME_DIR .. "3rdparty/portmidi/pm_mac/osxsupport.m",
			MAME_DIR .. "3rdparty/portmidi/porttime/ptmacosx_mach.c",
		}
	end
else
links {
	ext_lib("portmidi"),
}
end
end
--------------------------------------------------
-- BGFX library objects
--------------------------------------------------

project "bgfx"
	uuid "d3e7e119-35cf-4f4f-aba0-d3bdcd1b879a"
	kind "StaticLib"

	configuration { "vs*" }
		buildoptions {
			"/wd4324", -- warning C4324: 'xxx' : structure was padded due to __declspec(align())
			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
			"/wd4611", -- warning C4611: interaction between '_setjmp' and C++ object destruction is non-portable
			"/wd4310", -- warning C4310: cast truncates constant value
		}
if _OPTIONS["vs"]=="intel-15" then
		buildoptions {
			"/Qwd906",              -- message #906: effect of this "#pragma pack" directive is local to function "xxx"
			"/Qwd1879",             -- warning #1879: unimplemented pragma ignored
			"/Qwd82",               -- remark #82: storage class is not first
		}
end
	configuration { }

	includedirs {
		MAME_DIR .. "3rdparty/bgfx/include",
		MAME_DIR .. "3rdparty/bgfx/3rdparty",
		MAME_DIR .. "3rdparty/bx/include",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/dxsdk/include",
	}

	configuration { "not steamlink"}
		includedirs {
			MAME_DIR .. "3rdparty/bgfx/3rdparty/khronos",
		}

	configuration { "android-*"}
		buildoptions {
			"-Wno-macro-redefined",
		}

	configuration { "vs*" }
		includedirs {
			MAME_DIR .. "3rdparty/bx/include/compat/msvc",
		}
	configuration { "mingw*" }
		includedirs {
			MAME_DIR .. "3rdparty/bx/include/compat/mingw",
		}

	configuration { "osx* or xcode4" }
		includedirs {
			MAME_DIR .. "3rdparty/bx/include/compat/osx",
		}

	configuration { "freebsd" }
		includedirs {
			MAME_DIR .. "3rdparty/bx/include/compat/freebsd",
		}

	configuration { "netbsd" }
		includedirs {
			MAME_DIR .. "3rdparty/bx/include/compat/freebsd",
		}

	configuration { "gmake" }
		buildoptions {
			"-Wno-uninitialized",
			"-Wno-unused-function",
			"-Wno-unused-but-set-variable",
		}
	configuration { "rpi" }
		buildoptions {
			"-Wno-unused-but-set-variable",
			"-Wno-unused-variable",
		}
		defines {
			"__STDC_VERSION__=199901L",
		}

	configuration { }

	if _OPTIONS["targetos"]=="windows" then
		local version = str_to_version(_OPTIONS["gcc_version"])
		if _OPTIONS["gcc"]~=nil and string.find(_OPTIONS["gcc"], "clang") then
			buildoptions {
				"-Wno-unknown-attributes",
				"-Wno-missing-braces",
				"-Wno-int-to-pointer-cast",
			}
		end
	end

	if _OPTIONS["targetos"]=="macosx" then
		local version = str_to_version(_OPTIONS["gcc_version"])
		if _OPTIONS["gcc"]~=nil and string.find(_OPTIONS["gcc"], "clang") then
			buildoptions {
				"-Wno-switch",
			}
			buildoptions_cpp {
				"-Wno-unknown-pragmas",
			}
		end
	end

	defines {
		"__STDC_LIMIT_MACROS",
		"__STDC_FORMAT_MACROS",
		"__STDC_CONSTANT_MACROS",
		"BGFX_CONFIG_MAX_FRAME_BUFFERS=128",
	}
	files {
		MAME_DIR .. "3rdparty/bgfx/src/bgfx.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/glcontext_egl.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/glcontext_glx.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/glcontext_ppapi.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/glcontext_wgl.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/image.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/hmd_ovr.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/hmd_openvr.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_d3d12.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_d3d11.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_d3d9.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_gl.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_null.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/renderer_vk.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/debug_renderdoc.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/shader.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/shader_dxbc.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/shader_dx9bc.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/shader_spirv.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/topology.cpp",
		MAME_DIR .. "3rdparty/bgfx/src/vertexdecl.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/bgfx_utils.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/bounds.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/camera.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/cube_atlas.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/font/font_manager.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/font/text_buffer_manager.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/font/text_metrics.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/font/utf8.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/imgui/imgui.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/imgui/ocornut_imgui.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/imgui/scintilla.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/nanovg/nanovg.cpp",
		MAME_DIR .. "3rdparty/bgfx/examples/common/nanovg/nanovg_bgfx.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ib-compress/indexbuffercompression.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ib-compress/indexbufferdecompression.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ocornut-imgui/imgui.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ocornut-imgui/imgui_demo.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ocornut-imgui/imgui_draw.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ocornut-imgui/imgui_node_graph_test.cpp",
		MAME_DIR .. "3rdparty/bgfx/3rdparty/ocornut-imgui/imgui_wm.cpp",
	}
	if _OPTIONS["targetos"]=="macosx" then
		files {
			MAME_DIR .. "3rdparty/bgfx/src/glcontext_eagl.mm",
			MAME_DIR .. "3rdparty/bgfx/src/glcontext_nsgl.mm",
			MAME_DIR .. "3rdparty/bgfx/src/renderer_mtl.mm",
		}
	end

--------------------------------------------------
-- PortAudio library objects
--------------------------------------------------
--
--if not _OPTIONS["with-system-portaudio"] then
--project "portaudio"
--	uuid "0755c5f5-eccf-47f3-98a9-df67018a94d4"
--	kind "StaticLib"
--
--	configuration { "vs*" }
--		buildoptions {
--			"/wd4245", -- warning C4245: 'conversion' : conversion from 'type1' to 'type2', signed/unsigned mismatch
--			"/wd4244", -- warning C4244: 'argument' : conversion from 'xxx' to 'xxx', possible loss of data
--			"/wd4100", -- warning C4100: 'xxx' : unreferenced formal parameter
--			"/wd4389", -- warning C4389: 'operator' : signed/unsigned mismatch
--			"/wd4189", -- warning C4189: 'xxx' : local variable is initialized but not referenced
--			"/wd4127", -- warning C4127: conditional expression is constant
--		}
--if _OPTIONS["vs"]=="intel-15" then
--		buildoptions {
--			"/Qwd869",              -- remark #869: parameter "xxx" was never referenced
--			"/Qwd1478",             -- warning #1478: function "xxx" (declared at line yyy of "zzz") was declared deprecated
--			"/Qwd2544",             -- message #2544: empty dependent statement in if-statement
--			"/Qwd1879",             -- warning #1879: unimplemented pragma ignored
--		}
--end
--	configuration { "vs2015" }
--		buildoptions {
--			"/wd4456", -- warning C4456: declaration of 'xxx' hides previous local declaration
--		}
--
--	configuration { "gmake" }
--		buildoptions_c {
--			"-Wno-strict-prototypes",
--			"-Wno-bad-function-cast",
--			"-Wno-undef",
--			"-Wno-missing-braces",
--			"-Wno-unused-variable",
--			"-Wno-unused-value",
--			"-Wno-unused-function",
--			"-Wno-unknown-pragmas",
--		}
--
--	local version = str_to_version(_OPTIONS["gcc_version"])
--	if (_OPTIONS["gcc"]~=nil) then
--		if string.find(_OPTIONS["gcc"], "clang") or string.find(_OPTIONS["gcc"], "android") then
--			buildoptions_c {
--				"-Wno-unknown-warning-option",
--				"-Wno-absolute-value",
--				"-Wno-unused-but-set-variable",
--				"-Wno-maybe-uninitialized",
--				"-Wno-sometimes-uninitialized",
--			}
--		else
--			if (version >= 40600) then
--				buildoptions_c {
--					"-Wno-unused-but-set-variable",
--					"-Wno-maybe-uninitialized",
--					"-Wno-sometimes-uninitialized",
--				}
--			end
--		end
--	end
--	configuration { "vs*" }
--		buildoptions {
--			"/wd4204", -- warning C4204: nonstandard extension used : non-constant aggregate initializer
--			"/wd4701", -- warning C4701: potentially uninitialized local variable 'xxx' used
--		}
--
--	configuration { }
--
--	includedirs {
--		MAME_DIR .. "3rdparty/portaudio/include",
--		MAME_DIR .. "3rdparty/portaudio/src/common",
--	}
--
--	files {
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_allocation.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_converters.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_cpuload.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_dither.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_debugprint.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_front.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_process.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_stream.c",
--		MAME_DIR .. "3rdparty/portaudio/src/common/pa_trace.c",
--		MAME_DIR .. "3rdparty/portaudio/src/hostapi/skeleton/pa_hostapi_skeleton.c",
--	}
--
--	if _OPTIONS["targetos"]=="windows" then
--		defines {
--			"PA_USE_DS=1",
--			"PA_USE_WDMKS=1",
--			"PA_USE_WMME=1",
--		}
--		includedirs {
--			MAME_DIR .. "3rdparty/portaudio/src/os/win",
--		}
--
--		configuration { }
--		files {
--			MAME_DIR .. "3rdparty/portaudio/src/os/win/pa_win_util.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/win/pa_win_waveformat.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/win/pa_win_hostapis.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/win/pa_win_wdmks_utils.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/win/pa_win_coinitialize.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/dsound/pa_win_ds.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/dsound/pa_win_ds_dynlink.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/wdmks/pa_win_wdmks.c",
--			MAME_DIR .. "3rdparty/portaudio/src/common/pa_ringbuffer.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/wmme/pa_win_wmme.c",
--		}
--
--	end
--	if _OPTIONS["targetos"]=="linux" then
--		defines {
--			"PA_USE_ALSA=1",
--			"PA_USE_OSS=1",
--			"HAVE_LINUX_SOUNDCARD_H",
--		}
--		includedirs {
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix",
--		}
--		files {
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix/pa_unix_hostapis.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix/pa_unix_util.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/alsa/pa_linux_alsa.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/oss/pa_unix_oss.c",
--		}
--	end
--	if _OPTIONS["targetos"]=="macosx" then
--		defines {
--			"PA_USE_COREAUDIO=1",
--		}
--		includedirs {
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix",
--		}
--		files {
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix/pa_unix_hostapis.c",
--			MAME_DIR .. "3rdparty/portaudio/src/os/unix/pa_unix_util.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/coreaudio/pa_mac_core.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/coreaudio/pa_mac_core_utilities.c",
--			MAME_DIR .. "3rdparty/portaudio/src/hostapi/coreaudio/pa_mac_core_blocking.c",
--			MAME_DIR .. "3rdparty/portaudio/src/common/pa_ringbuffer.c",
--		}
--	end
--
--else
--links {
--	ext_lib("portaudio"),
--}
--end

--------------------------------------------------
-- libuv library objects
--------------------------------------------------
if _OPTIONS["USE_LIBUV"]=="1" then
if not _OPTIONS["with-system-uv"] then
project "uv"
	uuid "cd2afe7f-139d-49c3-9000-fc9119f3cea0"
	kind "StaticLib"

	includedirs {
		MAME_DIR .. "3rdparty/libuv/include",
		MAME_DIR .. "3rdparty/libuv/src",
		MAME_DIR .. "3rdparty/libuv/src/win",
	}

	configuration { "gmake" }
		buildoptions_c {
			"-Wno-strict-prototypes",
			"-Wno-bad-function-cast",
			"-Wno-write-strings",
			"-Wno-missing-braces",
			"-Wno-undef",
			"-Wno-unused-variable",
		}


	local version = str_to_version(_OPTIONS["gcc_version"])
	if (_OPTIONS["gcc"]~=nil) then
		if string.find(_OPTIONS["gcc"], "clang") or string.find(_OPTIONS["gcc"], "android") then
			buildoptions_c {
				"-Wno-unknown-warning-option",
				"-Wno-unknown-attributes",
				"-Wno-null-dereference",
				"-Wno-unused-but-set-variable",
				"-Wno-maybe-uninitialized",
			}
		else
			buildoptions_c {
				"-Wno-unused-but-set-variable",
				"-Wno-maybe-uninitialized",
			}
		end
	end

	configuration { "vs*" }
		buildoptions {
			"/wd4054", -- warning C4054: 'type cast' : from function pointer 'xxx' to data pointer 'void *'
			"/wd4204", -- warning C4204: nonstandard extension used : non-constant aggregate initializer
			"/wd4210", -- warning C4210: nonstandard extension used : function given file scope
			"/wd4701", -- warning C4701: potentially uninitialized local variable 'xxx' used
			"/wd4703", -- warning C4703: potentially uninitialized local pointer variable 'xxx' used
			"/wd4477", -- warning C4477: '<function>' : format string '<format-string>' requires an argument of type '<type>', but variadic argument <position> has type '<type>'
		}

	configuration { }

	files {
			MAME_DIR .. "3rdparty/libuv/src/fs-poll.c",
			MAME_DIR .. "3rdparty/libuv/src/inet.c",
			MAME_DIR .. "3rdparty/libuv/src/threadpool.c",
			MAME_DIR .. "3rdparty/libuv/src/uv-common.c",
			MAME_DIR .. "3rdparty/libuv/src/version.c",
	}

	if _OPTIONS["targetos"]=="windows" then
		defines {
			"WIN32_LEAN_AND_MEAN",
			"_WIN32_WINNT=0x0502",
		}
		if _ACTION == "vs2013" then
			files {
				MAME_DIR .. "3rdparty/libuv/src/win/snprintf.c",
			}
		end
		configuration { }
		files {
			MAME_DIR .. "3rdparty/libuv/src/win/async.c",
			MAME_DIR .. "3rdparty/libuv/src/win/core.c",
			MAME_DIR .. "3rdparty/libuv/src/win/dl.c",
			MAME_DIR .. "3rdparty/libuv/src/win/error.c",
			MAME_DIR .. "3rdparty/libuv/src/win/fs-event.c",
			MAME_DIR .. "3rdparty/libuv/src/win/fs.c",
			MAME_DIR .. "3rdparty/libuv/src/win/getaddrinfo.c",
			MAME_DIR .. "3rdparty/libuv/src/win/getnameinfo.c",
			MAME_DIR .. "3rdparty/libuv/src/win/handle.c",
			MAME_DIR .. "3rdparty/libuv/src/win/loop-watcher.c",
			MAME_DIR .. "3rdparty/libuv/src/win/pipe.c",
			MAME_DIR .. "3rdparty/libuv/src/win/poll.c",
			MAME_DIR .. "3rdparty/libuv/src/win/process-stdio.c",
			MAME_DIR .. "3rdparty/libuv/src/win/process.c",
			MAME_DIR .. "3rdparty/libuv/src/win/req.c",
			MAME_DIR .. "3rdparty/libuv/src/win/signal.c",
			MAME_DIR .. "3rdparty/libuv/src/win/stream.c",
			MAME_DIR .. "3rdparty/libuv/src/win/tcp.c",
			MAME_DIR .. "3rdparty/libuv/src/win/thread.c",
			MAME_DIR .. "3rdparty/libuv/src/win/timer.c",
			MAME_DIR .. "3rdparty/libuv/src/win/tty.c",
			MAME_DIR .. "3rdparty/libuv/src/win/udp.c",
			MAME_DIR .. "3rdparty/libuv/src/win/util.c",
			MAME_DIR .. "3rdparty/libuv/src/win/winapi.c",
			MAME_DIR .. "3rdparty/libuv/src/win/winsock.c",
		}
	end

	if _OPTIONS["targetos"]~="windows" then
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/async.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/atomic-ops.h",
			MAME_DIR .. "3rdparty/libuv/src/unix/core.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/dl.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/fs.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/getaddrinfo.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/getnameinfo.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/internal.h",
			MAME_DIR .. "3rdparty/libuv/src/unix/loop-watcher.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/loop.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/pipe.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/poll.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/process.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/signal.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/spinlock.h",
			MAME_DIR .. "3rdparty/libuv/src/unix/stream.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/tcp.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/thread.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/timer.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/tty.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/udp.c",
		}
	end
	if _OPTIONS["targetos"]=="linux" then
		defines {
			"_GNU_SOURCE",
		}
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-core.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-inotify.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-syscalls.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-syscalls.h",
			MAME_DIR .. "3rdparty/libuv/src/unix/proctitle.c",
		}
	end
	if _OPTIONS["targetos"]=="macosx" then
		defines {
			"_DARWIN_USE_64_BIT_INODE=1",
			"_DARWIN_UNLIMITED_SELECT=1",
		}
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/darwin.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/darwin-proctitle.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/fsevents.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/kqueue.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/proctitle.c",
		}
	end

	if _OPTIONS["targetos"]=="android" then
		defines {
			"_GNU_SOURCE",
		}
		buildoptions {
			"-Wno-header-guard",
		}
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/proctitle.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-core.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-inotify.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-syscalls.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/linux-syscalls.h",
			MAME_DIR .. "3rdparty/libuv/src/unix/pthread-fixes.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/android-ifaddrs.c",
		}
	end

	if _OPTIONS["targetos"]=="solaris" then
		defines {
			"__EXTENSIONS__",
			"_XOPEN_SOURCE=500",
		}
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/sunos.c",
		}
	end
	if _OPTIONS["targetos"]=="freebsd" then
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/freebsd.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/kqueue.c",
		}
	end
	if _OPTIONS["targetos"]=="netbsd" then
		files {
			MAME_DIR .. "3rdparty/libuv/src/unix/netbsd.c",
			MAME_DIR .. "3rdparty/libuv/src/unix/kqueue.c",
		}
		links {
			"kvm",
		}
	end	

	if (_OPTIONS["SHADOW_CHECK"]=="1") then
		removebuildoptions {
			"-Wshadow"
		}
	end
end

end
--------------------------------------------------
-- SDL2 library
--------------------------------------------------
if _OPTIONS["with-bundled-sdl2"] then
project "SDL2"
	uuid "caab3327-574f-4abf-b25b-74d5238ae59b"
if _OPTIONS["targetos"]=="android" then
	kind "SharedLib"
	targetextension ".so"
	targetprefix "lib"
	links {
		"GLESv1_CM",
		"GLESv2",
		"log",
	}
	linkoptions {
		"-Wl,-soname,libSDL2.so"
	}

	if _OPTIONS["SEPARATE_BIN"]~="1" then
		if _OPTIONS["PLATFORM"]=="arm" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/armeabi-v7a")
		end
		if _OPTIONS["PLATFORM"]=="arm64" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/arm64-v8a")
		end
		if _OPTIONS["PLATFORM"]=="mips" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/mips")
		end
		if _OPTIONS["PLATFORM"]=="mips64" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/mips64")
		end
		if _OPTIONS["PLATFORM"]=="x86" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/x86")
		end
		if _OPTIONS["PLATFORM"]=="x64" then
			targetdir(MAME_DIR .. "android-project/app/src/main/libs/x86_64")
		end
	end
else
	kind "StaticLib"
end

	files {
		MAME_DIR .. "3rdparty/SDL2/include/begin_code.h",
		MAME_DIR .. "3rdparty/SDL2/include/close_code.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_assert.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_atomic.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_audio.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_bits.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_blendmode.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_clipboard.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_config.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_config_windows.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_copying.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_cpuinfo.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_egl.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_endian.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_error.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_events.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_filesystem.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_gamecontroller.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_gesture.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_haptic.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_hints.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_joystick.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_keyboard.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_keycode.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_loadso.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_log.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_main.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_messagebox.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_mouse.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_mutex.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_name.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengl.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengl_glext.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles2.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles2_gl2.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles2_gl2ext.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles2_gl2platform.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_opengles2_khrplatform.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_pixels.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_platform.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_power.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_quit.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_rect.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_render.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_revision.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_rwops.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_scancode.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_shape.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_stdinc.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_surface.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_system.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_syswm.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_assert.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_common.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_compare.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_crc32.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_font.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_fuzzer.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_harness.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_images.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_log.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_md5.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_test_random.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_thread.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_timer.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_touch.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_types.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_version.h",
		MAME_DIR .. "3rdparty/SDL2/include/SDL_video.h",


		MAME_DIR .. "3rdparty/SDL2/src/atomic/SDL_atomic.c",
		MAME_DIR .. "3rdparty/SDL2/src/atomic/SDL_spinlock.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/disk/SDL_diskaudio.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/disk/SDL_diskaudio.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/dummy/SDL_dummyaudio.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/dummy/SDL_dummyaudio.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audio.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audio_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audiocvt.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audiodev.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audiodev_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audiomem.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_audiotypecvt.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_mixer.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_sysaudio.h",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_wave.c",
		MAME_DIR .. "3rdparty/SDL2/src/audio/SDL_wave.h",
		MAME_DIR .. "3rdparty/SDL2/src/cpuinfo/SDL_cpuinfo.c",
		MAME_DIR .. "3rdparty/SDL2/src/dynapi/SDL_dynapi.c",
		MAME_DIR .. "3rdparty/SDL2/src/dynapi/SDL_dynapi.h",
		MAME_DIR .. "3rdparty/SDL2/src/dynapi/SDL_dynapi_overrides.h",
		MAME_DIR .. "3rdparty/SDL2/src/dynapi/SDL_dynapi_procs.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/blank_cursor.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/default_cursor.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_clipboardevents.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_clipboardevents_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_dropevents.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_dropevents_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_events.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_events_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_gesture.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_gesture_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_keyboard.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_keyboard_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_mouse.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_mouse_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_quit.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_sysevents.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_touch.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_touch_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_windowevents.c",
		MAME_DIR .. "3rdparty/SDL2/src/events/SDL_windowevents_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/file/SDL_rwops.c",
		MAME_DIR .. "3rdparty/SDL2/src/haptic/SDL_haptic.c",
		MAME_DIR .. "3rdparty/SDL2/src/haptic/SDL_syshaptic.h",
		MAME_DIR .. "3rdparty/SDL2/src/joystick/SDL_gamecontroller.c",
		MAME_DIR .. "3rdparty/SDL2/src/joystick/SDL_joystick.c",
		MAME_DIR .. "3rdparty/SDL2/src/joystick/SDL_joystick_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/joystick/SDL_sysjoystick.h",
		MAME_DIR .. "3rdparty/SDL2/src/loadso/windows/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL2/src/power/SDL_power.c",
		MAME_DIR .. "3rdparty/SDL2/src/power/windows/SDL_syspower.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/direct3d/SDL_render_d3d.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/direct3d11/SDL_render_d3d11.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/mmx.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/opengl/SDL_render_gl.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/opengl/SDL_shaders_gl.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/opengl/SDL_shaders_gl.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/opengles2/SDL_render_gles2.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/opengles2/SDL_shaders_gles2.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_d3dmath.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_d3dmath.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_render.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_sysrender.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_yuv_mmx.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_yuv_sw.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/SDL_yuv_sw_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendfillrect.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendfillrect.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendline.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendline.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendpoint.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_blendpoint.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_draw.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_drawline.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_drawline.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_drawpoint.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_drawpoint.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_render_sw.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_render_sw_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_rotate.c",
		MAME_DIR .. "3rdparty/SDL2/src/render/software/SDL_rotate.h",
		MAME_DIR .. "3rdparty/SDL2/src/SDL.c",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_assert.c",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_error.c",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_error_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_hints.c",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_hints_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/SDL_log.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_getenv.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_iconv.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_malloc.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_qsort.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_stdlib.c",
		MAME_DIR .. "3rdparty/SDL2/src/stdlib/SDL_string.c",
		MAME_DIR .. "3rdparty/SDL2/src/thread/SDL_systhread.h",
		MAME_DIR .. "3rdparty/SDL2/src/thread/SDL_thread.c",
		MAME_DIR .. "3rdparty/SDL2/src/thread/SDL_thread_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/timer/SDL_systimer.h",
		MAME_DIR .. "3rdparty/SDL2/src/timer/SDL_timer.c",
		MAME_DIR .. "3rdparty/SDL2/src/timer/SDL_timer_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullevents.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullevents_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullframebuffer.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullframebuffer_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullvideo.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/dummy/SDL_nullvideo.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_0.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_1.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_A.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_auto.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_auto.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_copy.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_copy.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_N.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_slow.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_blit_slow.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_bmp.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_clipboard.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_egl.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_fillrect.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_glesfuncs.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_glfuncs.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_pixels.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_pixels_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_rect.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_rect_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_RLEaccel.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_RLEaccel_c.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_shape.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_shape_internals.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_stretch.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_surface.c",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_sysvideo.h",
		MAME_DIR .. "3rdparty/SDL2/src/video/SDL_video.c",

	}
	if _OPTIONS["targetos"]=="macosx" or _OPTIONS["targetos"]=="windows" then
		files {
			MAME_DIR .. "3rdparty/SDL2/src/libm/e_atan2.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/e_log.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/e_pow.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/e_rem_pio2.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/e_sqrt.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/k_cos.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/k_rem_pio2.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/k_sin.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/k_tan.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/math.h",
			MAME_DIR .. "3rdparty/SDL2/src/libm/math_private.h",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_atan.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_copysign.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_cos.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_fabs.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_floor.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_scalbn.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_sin.c",
			MAME_DIR .. "3rdparty/SDL2/src/libm/s_tan.c",
		}
	end
	if _OPTIONS["targetos"]~="windows" then
		files {
			MAME_DIR .. "3rdparty/SDL2/src/render/opengles/SDL_render_gles.c",
			MAME_DIR .. "3rdparty/SDL2/src/render/opengles/SDL_glesfuncs.h",
		}
	end

	if _OPTIONS["targetos"]=="android" then
		files {
			MAME_DIR .. "3rdparty/SDL2/src/audio/android/SDL_androidaudio.c",
			MAME_DIR .. "3rdparty/SDL2/src/audio/android/SDL_androidaudio.h",
			MAME_DIR .. "3rdparty/SDL2/src/core/android/SDL_android.c",
			MAME_DIR .. "3rdparty/SDL2/src/core/android/SDL_android.h",
			MAME_DIR .. "3rdparty/SDL2/src/filesystem/android/SDL_sysfilesystem.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/dummy/SDL_syshaptic.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/android/SDL_sysjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/loadso/dlopen/SDL_sysloadso.c",
			MAME_DIR .. "3rdparty/SDL2/src/power/android/SDL_syspower.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_syscond.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_sysmutex.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_sysmutex_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_syssem.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systhread.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systhread_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systls.c",
			MAME_DIR .. "3rdparty/SDL2/src/timer/unix/SDL_systimer.c",
			MAME_DIR .. "3rdparty/SDL2/src/timer/unix/SDL_systimer_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidclipboard.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidclipboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidevents.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidevents.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidgl.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidkeyboard.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidkeyboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidmessagebox.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidmessagebox.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidmouse.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidmouse.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidtouch.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidtouch.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidvideo.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidvideo.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidwindow.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/android/SDL_androidwindow.h",
		}
	end

	if _OPTIONS["targetos"]=="macosx" then
		files {
			MAME_DIR .. "3rdparty/SDL2/src/audio/coreaudio/SDL_coreaudio.c",
			MAME_DIR .. "3rdparty/SDL2/src/audio/coreaudio/SDL_coreaudio.h",
			MAME_DIR .. "3rdparty/SDL2/src/file/cocoa/SDL_rwopsbundlesupport.m",
			MAME_DIR .. "3rdparty/SDL2/src/file/cocoa/SDL_rwopsbundlesupport.h",
			MAME_DIR .. "3rdparty/SDL2/src/filesystem/cocoa/SDL_sysfilesystem.m",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/darwin/SDL_syshaptic.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/darwin/SDL_syshaptic_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/darwin/SDL_sysjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/darwin/SDL_sysjoystick_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/loadso/dlopen/SDL_sysloadso.c",
			MAME_DIR .. "3rdparty/SDL2/src/power/macosx/SDL_syspower.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_syscond.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_sysmutex.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_sysmutex_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_syssem.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systhread.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systhread_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/pthread/SDL_systls.c",
			MAME_DIR .. "3rdparty/SDL2/src/timer/unix/SDL_systimer.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaclipboard.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaclipboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaevents.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaevents.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoakeyboard.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoakeyboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamessagebox.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamessagebox.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamodes.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamodes.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamouse.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamouse.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamousetap.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoamousetap.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaopengl.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoaopengl.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoashape.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoashape.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoavideo.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoavideo.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoawindow.m",
			MAME_DIR .. "3rdparty/SDL2/src/video/cocoa/SDL_cocoawindow.h",

		}
	end

	if _OPTIONS["targetos"]=="windows" then
		files {
			MAME_DIR .. "3rdparty/SDL2/src/thread/generic/SDL_syscond.c",
			MAME_DIR .. "3rdparty/SDL2/src/audio/directsound/SDL_directsound.c",
			MAME_DIR .. "3rdparty/SDL2/src/audio/directsound/SDL_directsound.h",
			MAME_DIR .. "3rdparty/SDL2/src/audio/winmm/SDL_winmm.c",
			MAME_DIR .. "3rdparty/SDL2/src/audio/winmm/SDL_winmm.h",
			MAME_DIR .. "3rdparty/SDL2/src/core/windows/SDL_directx.h",
			MAME_DIR .. "3rdparty/SDL2/src/core/windows/SDL_windows.c",
			MAME_DIR .. "3rdparty/SDL2/src/core/windows/SDL_windows.h",
			MAME_DIR .. "3rdparty/SDL2/src/core/windows/SDL_xinput.c",
			MAME_DIR .. "3rdparty/SDL2/src/core/windows/SDL_xinput.h",
			MAME_DIR .. "3rdparty/SDL2/src/filesystem/windows/SDL_sysfilesystem.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_dinputhaptic.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_dinputhaptic_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_windowshaptic.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_windowshaptic_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_xinputhaptic.c",
			MAME_DIR .. "3rdparty/SDL2/src/haptic/windows/SDL_xinputhaptic_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_dinputjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_dinputjoystick_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_mmjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_windowsjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_windowsjoystick_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_xinputjoystick.c",
			MAME_DIR .. "3rdparty/SDL2/src/joystick/windows/SDL_xinputjoystick_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/windows/SDL_sysmutex.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/windows/SDL_syssem.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/windows/SDL_systhread.c",
			MAME_DIR .. "3rdparty/SDL2/src/thread/windows/SDL_systhread_c.h",
			MAME_DIR .. "3rdparty/SDL2/src/thread/windows/SDL_systls.c",
			MAME_DIR .. "3rdparty/SDL2/src/timer/windows/SDL_systimer.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_vkeys.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsclipboard.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsclipboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsevents.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsevents.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsframebuffer.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsframebuffer.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowskeyboard.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowskeyboard.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmessagebox.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmessagebox.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmodes.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmodes.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmouse.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsmouse.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsopengl.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsopengl.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsopengles.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsshape.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsshape.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsvideo.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowsvideo.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowswindow.c",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/SDL_windowswindow.h",
			MAME_DIR .. "3rdparty/SDL2/src/video/windows/wmmsg.h",
			MAME_DIR .. "3rdparty/SDL2/src/main/windows/version.rc",
		}
	end

	configuration { "vs*" }
		files {
			MAME_DIR .. "3rdparty/SDL2/src/audio/xaudio2/SDL_xaudio2.c",
		}

		buildoptions {
			"/wd4200", -- warning C4200: nonstandard extension used: zero-sized array in struct/union
			"/wd4055", -- warning C4055: 'type cast': from data pointer 'void *' to function pointer 'xxx'
			"/wd4152", -- warning C4152: nonstandard extension, function/data pointer conversion in expression
			"/wd4057", -- warning C4057: 'function': 'xxx' differs in indirection to slightly different base types from 'xxx'
			"/wd4701", -- warning C4701: potentially uninitialized local variable 'xxx' used
			"/wd4204", -- warning C4204: nonstandard extension used: non-constant aggregate initializer
			"/wd4054", -- warning C4054: 'type cast': from function pointer 'xxx' to data pointer 'xxx'
		}
		defines {
			"HAVE_LIBC",
		}

	configuration { "mingw*"}
		includedirs {
			MAME_DIR .. "3rdparty/SDL2-override/mingw",
			MAME_DIR .. "3rdparty/bgfx/3rdparty/khronos",
		}
		buildoptions_c {
			"-Wno-undef",
			"-Wno-strict-prototypes",
			"-Wno-bad-function-cast",
			"-Wno-discarded-qualifiers",
			"-Wno-unused-but-set-variable",
		}

	configuration { "osx*"}
		buildoptions {
			"-Wno-undef",
		}
		buildoptions_objc {
			"-x objective-c",
			"-std=c99",
		}

		buildoptions_c {
			"-Wno-bad-function-cast",
		}

	configuration { "android-*"}
		defines {
			"GL_GLEXT_PROTOTYPES",
		}
		buildoptions_c {
			"-Wno-bad-function-cast",
			"-Wno-incompatible-pointer-types-discards-qualifiers",
			"-Wno-unneeded-internal-declaration",
			"-Wno-unused-const-variable",
		}

	configuration { }
		includedirs {
			MAME_DIR .. "3rdparty/SDL2/include",
		}

end

--------------------------------------------------
-- SDL2 library
--------------------------------------------------
if _OPTIONS["with-bundled-sdl1"] then
project "SDL1"
	uuid "daab3327-574f-4abf-b25b-74d5238ae59b"

	kind "StaticLib"
	files {
		MAME_DIR .. "3rdparty/SDL1/SDL_ttf-2.0.11/SDL_ttf.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/AudioFilePlayer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/SDL_syscdrom_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/SDLOSXCAGuard.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/CDPlayer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macos/SDL_syscdrom_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/SDL_syscdrom.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/SDL_error_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/mint/SDL_vbltimer_s.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/macos/FastTimes.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/SDL_systimer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/SDL_timer_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/macosx/SDLMain.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/beos/SDL_BeApp.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA2/vectorbuffer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/macosx/SDL_coreaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/pulse/SDL_pulseaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audiomem.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_m68k.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nds/soundcommon.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nds/SDL_ndsaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mme/SDL_mmeaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dc/SDL_dcaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dc/aica.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dart/SDL_dart.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/symbian/streamplayer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/symbian/SDL_epocaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nas/SDL_nasaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dummy/SDL_dummyaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dsp/SDL_dspaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/bsd/SDL_bsdaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dmedia/SDL_irixaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/ums/SDL_umsaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/disk/SDL_diskaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_dma8.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_gsxb.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_stfa.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_mcsn.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/baudio/SDL_beaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_MMX.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/windx5/directx.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/windx5/SDL_dx5audio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audio_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/sun/SDL_sunaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nto/SDL_nto_audio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/arts/SDL_artsaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/esd/SDL_esdaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/windib/SDL_dibaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/macrom/SDL_romaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_wave.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/paudio/SDL_paudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_MMX_VC.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audiodev_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dma/SDL_dmaaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/alsa/SDL_alsa_audio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_sysaudio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_sysmutex_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_sysmutex_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/beos/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_sysmutex_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_syssem_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_syscond_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/SDL_thread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pth/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pth/SDL_sysmutex_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/symbian/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/win_ce_semaphore.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/SDL_systhread.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/irix/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_sysmutex_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_systhread_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_syscond_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscostask.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/macdsp/SDL_dspvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/default_cursor.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_QPEApp.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_lowvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_sysmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_syswm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_QWin.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_sysevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/os2fslib/SDL_os2fslib.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/os2fslib/SDL_vkeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_events.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_keys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_yuv.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_sysvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_stretch_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_RLEaccel_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/blank_cursor.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_pixels_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_yuvfuncs.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/SDL_epocevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA1/SDL_epocvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/SDL_epocvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarimxalloc_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ikbdevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarisuper.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarievents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarieddi_s.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_xbiosinterrupt_s.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_xbiosevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ataridevmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarigl_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ataric2p_s.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ikbdinterrupt_s.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_gemdosevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_biosevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarikeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_leaks.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsyuv_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gskeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ipod/SDL_ipodvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/caca/SDL_cacaevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/caca/SDL_cacavideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/math_private.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aamouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aavideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aaevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggimouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggivideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggievents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggikeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_cursor_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5yuv_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5events_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/directx.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11dyn.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11modes_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11wm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11gamma_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11gl_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11events_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11dga_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11mouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11image_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11yuv_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11sym.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/e_sqrt.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_phyuv_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_gl.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_wm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_events_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_image_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_mouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_modes_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/mmx.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemwm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/wmmsg.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_wingl_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_lowvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_sysmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_syswm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gapi/SDL_gapivideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_dibevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_dibvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_gapidibvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_vkeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_yuv_sw_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/matrox_regs.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fb3dfx.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/riva_regs.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/3dfx_regs.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbriva.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbmatrox.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/matrox_mmio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/3dfx_mmio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbelo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/riva_mmio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbkeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_mackeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_lowvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macwm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macgl_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/macrom/SDL_romvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/picogui/SDL_pgvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/picogui/SDL_pgevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/e_pow.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/quartz/CGS.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/quartz/SDL_QuartzVideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/quartz/SDL_QuartzWindow.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/quartz/SDL_QuartzWM.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/quartz/SDL_QuartzKeys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xme.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86vmstr.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/Xext.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/panoramiXproto.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/panoramiXext.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86dga1.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86dga1str.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/Xvproto.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86vmode.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86dgastr.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/Xv.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/Xinerama.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/xf86dga.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/Xvlib.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/extensions/extutil.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xv/Xvlibint.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgaevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgamouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgavideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysyuv.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_lowvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_BWin.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_BView.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_syswm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxmouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxvideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nximage_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxwm_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxmodes_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/e_log.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_blowup.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_centscreen.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_milan.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_sb3.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_tveille.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_glfuncs.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgamouse_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgaevents_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgavideo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3yuv_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/spulibs/spu_common.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3events_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/SDL_joystick_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/SDL_sysjoystick.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_events_c.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_sysevents.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/SDL_fatal.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/hermes/HeadX86.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/hermes/HeadMMX.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_minimal.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_nds.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_keyboard.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_rwops.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_getenv.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_audio.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_timer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_events.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_byteorder.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_mouse.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_symbian.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_syswm.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_types.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_quit.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_keysym.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_active.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_loadso.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_dreamcast.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/begin_code.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_macos.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_video.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_mutex.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_opengl.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_platform.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_thread.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_error.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_endian.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_name.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_version.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/close_code.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_cdrom.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_win32.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_cpuinfo.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_os2.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_joystick.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_stdinc.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_config_macosx.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_copying.h",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/include/SDL_main.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_ogg.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_ogg.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/effects_internal.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_cmd.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/fluidsynth.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_aiff.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_mod.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_flac.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/wavestream.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_fluidsynth.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_mp3.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_mod.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_flac.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_mad.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_common.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_voc.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/output.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/timidity.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/mix.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/config.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/common.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/tables.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/instrum.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/ctrlmode.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/playmidi.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/resample.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/readmidi.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/filter.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_ogg.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_flac.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_modplug.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/SDL_mixer.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/chat.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDLnetsys.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDL_net.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/SDL_image.h",
		MAME_DIR .. "3rdparty/SDL1/SDL_ttf-2.0.11/showfont.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_ttf-2.0.11/SDL_ttf.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_ttf-2.0.11/glfont.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testver.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testtimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testblitspeed.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testwin.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testiconv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testoverlay2.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/threadwin.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testwm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testgamma.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testoverlay.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testkeys.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testsprite.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/loopwave.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testerror.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/torturethread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testalpha.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testsem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testfile.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testlock.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testcdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testgl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testdyngl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/graywin.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testbitmap.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testvidinfo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testcursor.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testplatform.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/testpalette.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/test/checkkeys.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/linux/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/bsdi/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/CDPlayer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/SDLOSXCAGuard.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/AudioFileReaderThread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macosx/AudioFilePlayer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/dc/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/aix/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/dummy/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/win32/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/mint/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/osf/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/macos/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/qnx/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/freebsd/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/os2/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/SDL_cdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/openbsd/SDL_syscdrom.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cpuinfo/SDL_cpuinfo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/file/SDL_rwops.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/riscos/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/beos/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/nds/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/dc/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/dummy/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/win32/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/wince/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/mint/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/macos/SDL_MPWtimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/macos/FastTimes.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/macos/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/SDL_timer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/os2/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/unix/SDL_systimer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/dummy/SDL_dummy_main.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/win32/SDL_win32_main.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/macos/SDL_main.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/SDL.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/macosx/SDL_coreaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/pulse/SDL_pulseaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nds/sound9.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nds/SDL_ndsaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mme/SDL_mmeaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dc/aica.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dc/SDL_dcaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dart/SDL_dart.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nas/SDL_nasaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dummy/SDL_dummyaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dsp/SDL_dspaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/bsd/SDL_bsdaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dmedia/SDL_irixaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/ums/SDL_umsaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/disk/SDL_diskaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_dma8.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_gsxb.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_xbios.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_mcsn.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/mint/SDL_mintaudio_stfa.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_m68k.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/windx5/SDL_dx5audio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_MMX_VC.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/sun/SDL_sunaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/nto/SDL_nto_audio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/arts/SDL_artsaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audiocvt.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/esd/SDL_esdaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/windib/SDL_dibaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/macrom/SDL_romaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_audiodev.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/paudio/SDL_paudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_wave.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/SDL_mixer_MMX.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/dma/SDL_dmaaudio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/alsa/SDL_alsa_audio.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/SDL_error.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_string.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_stdlib.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_malloc.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_qsort.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_iconv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/stdlib/SDL_getenv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/riscos/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/generic/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/beos/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/beos/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/dc/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pth/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pth/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pth/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/win_ce_semaphore.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/win32/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/irix/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/irix/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/pthread/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/SDL_thread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_syssem.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_sysmutex.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_syscond.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/os2/SDL_systhread.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_wimppoll.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscosFullScreenVideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscostask.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_wimpvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/riscos/SDL_riscossprite.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/macdsp/SDL_dspvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/vgl/SDL_vglmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/os2fslib/SDL_os2fslib.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_yuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/directfb/SDL_DirectFB_video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nds/SDL_ndsevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_gamma.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_yuv_mmx.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dc/SDL_dcvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_cursor.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit_1.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_xbiosevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ataridevmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarigl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarimxalloc.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_ikbdevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_gemdosevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_atarievents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ataricommon/SDL_biosevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dummy/SDL_nullmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsyuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps2gs/SDL_gsvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ipod/SDL_ipodvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/caca/SDL_cacaevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/caca/SDL_cacavideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aamouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aavideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/aalib/SDL_aaevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit_N.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_bmp.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggimouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggievents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ggi/SDL_ggivideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5yuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windx5/SDL_dx5events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11mouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11wm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11yuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11dyn.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11gamma.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11dga.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11image.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11gl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/x11/SDL_x11modes.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_gl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_phyuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_image.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_wm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_modes.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/photon/SDL_ph_mouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemwm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gem/SDL_gemvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_sysevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_syswm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_sysmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wincommon/SDL_wingl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/gapi/SDL_gapivideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/wscons/SDL_wsconsmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit_A.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_dibvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/windib/SDL_dibevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit_0.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fb3dfx.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbriva.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbelo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/fbcon/SDL_fbmatrox.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macwm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macgl.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/maccommon/SDL_macevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_surface.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/macrom/SDL_romvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_yuv_sw.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/picogui/SDL_pgevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/picogui/SDL_pgvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_yuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xxf86vm/XF86VMode.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/XME/xme.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xxf86dga/XF86DGA.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xxf86dga/XF86DGA2.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xv/Xv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/Xext/Xinerama/Xinerama.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgavideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgaevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/svga/SDL_svgamouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxmodes.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxvideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nximage.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxwm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/nanox/SDL_nxmouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_blit.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_centscreen.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_blowup.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_milan.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_sb3.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios_tveille.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/xbios/SDL_xbios.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_pixels.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_stretch.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/SDL_RLEaccel.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgamouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgavideo.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/dga/SDL_dgaevents.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3yuv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/SDL_ps3video.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/spulibs/yuv2rgb_converter.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/spulibs/fb_writer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/ps3/spulibs/bilin_scaler.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/riscos/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/linux/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/nds/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/dc/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/dummy/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/win32/SDL_mmjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/bsd/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/mint/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/macos/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/SDL_joystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/darwin/SDL_sysjoystick.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_resize.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_mouse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_quit.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_events.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_active.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_expose.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/events/SDL_keyboard.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/SDL_fatal.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/macosx/SDL_dlcompat.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/beos/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/dummy/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/win32/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/mint/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/macos/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/dlopen/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/loadso/os2/SDL_sysloadso.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_mod.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_aiff.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_ogg.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_fluidsynth.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_mod.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_flac.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/effect_position.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_voc.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_cmd.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_flac.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/fluidsynth.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_ogg.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_ogg.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/playwave.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_mac.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_macosx.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_common.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_win32.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/effects_internal.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/playmus.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/load_flac.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/resample.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/sdl_a.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/timidity.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/instrum.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/mix.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/common.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/ctrlmode.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/tables.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/output.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/playmidi.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/readmidi.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/sdl_c.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/timidity/filter.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/mixer.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_mad.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/effect_stereoreverse.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/dynamic_mp3.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/wavestream.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/music_modplug.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDLnetUDP.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDLnet.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/chatd.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDLnetTCP.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/SDLnetselect.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/showinterfaces.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_pcx.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_xv.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_jpg.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_png.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_webp.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/showimage.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_lbm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_gif.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_xcf.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_bmp.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_pnm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_xxx.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_tga.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_xpm.c",
		MAME_DIR .. "3rdparty/SDL1/SDL_image-1.2.12/IMG_tif.c",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/cdrom/beos/SDL_syscdrom.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/qtopia/SDL_qtopia_main.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/beos/SDL_BeApp.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/baudio/SDL_beaudio.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_syswm.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_sysvideo.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_QWin.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_sysevents.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_QPEApp.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/qtopia/SDL_sysmouse.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_syswm.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysvideo.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysyuv.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysevents.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/bwindow/SDL_sysmouse.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/joystick/beos/SDL_bejoystick.cc",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/timer/symbian/SDL_systimer.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA1/SDL_main.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA2/sdlexe.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA2/SDL_main.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA2/sdllib.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/main/symbian/EKA2/vectorbuffer.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/symbian/SDL_epocaudio.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/audio/symbian/streamplayer.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/symbian/SDL_syssem.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/symbian/SDL_sysmutex.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/thread/symbian/SDL_systhread.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA1/SDL_epocvideo.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA1/SDL_epocevents.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/dsa_new.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/dsa_old.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/SDL_epocvideo.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/dsa.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL-1.2.15/src/video/symbian/EKA2/SDL_epocevents.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL_mixer-1.2.12/native_midi/native_midi_haiku.cpp",
		MAME_DIR .. "3rdparty/SDL1/SDL_net-1.2.8/chat.cpp",
	}


	configuration { }
		includedirs {
			MAME_DIR .. "3rdparty/SDL1/include",
		}

end

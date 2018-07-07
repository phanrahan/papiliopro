# Makefile to compile and download a simple Verilog program

DEVICE=XC6SLX9
SPEED=3
PACKAGE=TQG144
PART=${DEVICE}-${SPEED}-${PACKAGE}
BSCAN=bscan_spi_${DEVICE}.bit

TARGET=main

default: ${TARGET}.xdl

${TARGET}.ngc: ${TARGET}.v
	@echo 'run'                 > xst.cmd
	@echo '-p $(PART)'         >> xst.cmd
	@echo '-ifn $(TARGET).v'   >> xst.cmd
	@echo '-ifmt verilog'      >> xst.cmd
	@echo '-ofn $(TARGET).ngc' >> xst.cmd
	@echo '-ofmt NGC' 	   >> xst.cmd
	@echo '-opt_mode Speed'	   >> xst.cmd
	@echo '-opt_level 1'	   >> xst.cmd
	xst -ifn xst.cmd

${TARGET}.ngd: ${TARGET}.ngc ${TARGET}.ucf
	ngdbuild -p $(PART) -uc ${TARGET}.ucf ${TARGET}.ngc

${TARGET}.xdl: ${TARGET}.ncd
	xdl -ncd2xdl ${TARGET}.ncd

${TARGET}.ncd: ${TARGET}.ngd
	map -detail -pr b ${TARGET}.ngd

${TARGET}.pcf: ${TARGET}.ngd
	map -detail -pr b ${TARGET}.ngd

parout.ncd: ${TARGET}.ncd
	par -w ${TARGET}.ncd parout.ncd ${TARGET}.pcf

parout.xdl: parout.ncd
	xdl -ncd2xdl parout.ncd

${TARGET}.bit: parout.ncd
	bitgen -w -g CRC:Enable -g StartUpClk:CClk \
   	  parout.ncd ${TARGET}.bit ${TARGET}.pcf

upload: ${TARGET}.bit
	papilio-prog -v -f ${TARGET}.bit -b ../${BSCAN} -sa -r
	papilio-prog -c

clean:
	rm -rf \
    ${TARGET}.bgn ${TARGET}.bin ${TARGET}.bit ${TARGET}.bld \
	${TARGET}.drc ${TARGET}.map ${TARGET}.mrp \
	${TARGET}.ncd ${TARGET}.ngc ${TARGET}.ngd \
	${TARGET}.ngm ${TARGET}.pcf ${TARGET}.prm \
	*.xwbt *.xrpt *.xdl *.xml *.html *.lst *.log parout* \ 
	xlnx_auto_0_xdb xst _xmsgs xst.cmd xst.srp


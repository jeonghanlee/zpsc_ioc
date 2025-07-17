#====================================================
#   Common St.cmd file used by zPSC devices
#====================================================
epicsEnvSet("LD_LIBRARY_PATH", "/usr/local/epics/base-7.0.9/lib/linux-x86_64:/usr/local/epics/pscdrv/lib/linux-x86_64")

## Register all support components
dbLoadDatabase "/epics/iocs/zpsc_ioc/dbd/zpsc.dbd"
zpsc_registerRecordDeviceDriver pdbbase

var(PSCDebug, 2)	#5 full debug

#psc1 Create the PSC
createPSC("PSC$(N)", $(PSC_IP), 3000, 0)

#!../../bin/linux-x86_64/zpsc
#--
< envPaths
#--
cd "${TOP}"
#--
#--https://epics-controls.org/resources-and-support/documents/howto-documents/channel-access-reach-multiple-soft-iocs-linux/
#--if one needs connections between IOCs on one host
#--add the broadcast address of the lookback interface to each IOC setting
epicsEnvSet("EPICS_CA_ADDR_LIST","127.255.255.255")
#--epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST","YES")

#-- PVXA Environment Variables
#-- epicsEnvSet("EPICS_PVA_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_AUTO_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_INTF_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVAS_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVA_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_IGNORE_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_CONN_TMO","")
#--
epicsEnvSet("DB_TOP",                "$(TOP)/db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")
epicsEnvSet("STREAM_PROTOCOL_PATH",  "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",       "$(TOP)/iocsh")
#--epicsEnvSet("IOCSH_TOP",            "$(EPICS_BASE)/../modules/soft/iocsh/iocsh")
#--
epicsEnvSet("ENGINEER",  "jeonglee")
epicsEnvSet("LOCATION",  "SoftIOC")
epicsEnvSet("WIKI", "")
#-- 
epicsEnvSet("IOCNAME", "alsulab-zpsc")
epicsEnvSet("IOC", "iocalsulab-zpsc")
#--
epicsEnvSet("PRE", "AAAA:")
epicsEnvSet("REC", "BBBB:")

# PSC IP address
epicsEnvSet("PSC1_IP", "10.0.142.115"); 

epicsEnvSet("BLEN",100000);        # Snapshot DMA Length



## Register all support components
dbLoadDatabase "dbd/zpsc.dbd"
zpsc_registerRecordDeviceDriver pdbbase


#--
#-- The following termination defintion should be in st.cmd or .iocsh. 
#-- Mostly, it should be .iocsh file. Please don't use them within .proto file
#--
#-- <0x0d> \r
#-- <0x0a> \n
#-- asynOctetSetInputEos($(PORT), 0, "\r")
#-- asynOctetSetOutputEos($(PORT), 0, "\r")

#--
#-- iocshLoad("$(IOCSH_TOP)/als_default.iocsh")
#-- iocshLoad("$(IOCSH_TOP)/iocLog.iocsh",    "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#--# Load record instances
#-- iocshLoad("$(IOCSH_TOP)/iocStats.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/iocStatsAdmin.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/reccaster.iocsh", "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/caPutLog.iocsh",  "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#-- iocshLoad("$(IOCSH_TOP)/autosave.iocsh", "AS_TOP=$(TOP),IOCNAME=$(IOCNAME),DATABASE_TOP=$(DB_TOP),SEQ_PERIOD=60")

#-- access control list
#--asSetFilename("$(DB_TOP)/access_securityalsulab-zpsc.acf")

cd "${TOP}/iocBoot/${IOC}"


var(PSCDebug, 2)	#5 full debug

#psc1 Create the PSC
createPSC("PSC1", $(PSC1_IP), 3000, 0)
setPSCSendBlockSize("PSC1", 1100, 512)


## Load record instances for PSC1
dbLoadRecords("$(DB_TOP)/lstats.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(DB_TOP)/status10hz.db", "P=$(IOCNAME), NO=1, OFFSET=100, BUFLEN=10000")
dbLoadRecords("$(DB_TOP)/control_glob.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(DB_TOP)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=1")
dbLoadRecords("$(DB_TOP)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=2")
dbLoadRecords("$(DB_TOP)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=3")
dbLoadRecords("$(DB_TOP)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=4")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("$(DB_TOP)/wfmstats.db", "P=$(IOCNAME), PSC=1")
#dbLoadRecords("$(DB_TOP)/asub_test.db")





#--epicsEnvSet("PORT1",      "AABBCCDD")
#--epicsEnvSet("PORT1_IP",   "xxx.xxx.xxx.xxx")
#--epicsEnvSet("PORT1_PORT", "xxxx")
#--iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "P=$(PRE),R=$(REC),DATABASE_TOP=$(DB_TOP),PORT=$(PORT1),IPADDR=$(PORT1_IP),IPPORT=$(PORT1_PORT)")

#>>>>>>>>>>>>>
iocInit
#>>>>>>>>>>>>>
##
##-- epicsEnvShow > /vxboot/PVenv/${IOCNAME}.softioc
##-- dbl > /vxboot/PVnames/${IOCNAME}
##-- iocshLoad("$(IOCSH_TOP)/after_iocInit.iocsh", "IOC=$(IOC),TRAGET_TOP=/vxboot")
##
# pvasr
ClockTime_Report
##
##
##
#--# Start any sequence programs
#--seq sncxxx,"user=jeonglee"
#--asynReport(1)
#-


epicsThreadSleep(1.0)



dbpf lab{1}Chan1:DigOut_ON1-SP 0
dbpf lab{1}Chan2:DigOut_ON1-SP 0
dbpf lab{1}Chan3:DigOut_ON1-SP 0
dbpf lab{1}Chan4:DigOut_ON1-SP 0

dbpf lab{1}Chan1:DigOut_ON2-SP 1
dbpf lab{1}Chan2:DigOut_ON2-SP 1
dbpf lab{1}Chan3:DigOut_ON2-SP 1
dbpf lab{1}Chan4:DigOut_ON2-SP 1

dbpf lab{1}Chan1:DigOut_Reset-SP 0
dbpf lab{1}Chan2:DigOut_Reset-SP 0
dbpf lab{1}Chan3:DigOut_Reset-SP 0
dbpf lab{1}Chan4:DigOut_Reset-SP 0

dbpf lab{1}Chan1:DigOut_Spare-SP 0
dbpf lab{1}Chan2:DigOut_Spare-SP 0
dbpf lab{1}Chan3:DigOut_Spare-SP 0
dbpf lab{1}Chan4:DigOut_Spare-SP 0


dbpf lab{1}Chan1:DigOut_Park-SP 0
dbpf lab{1}Chan2:DigOut_Park-SP 0
dbpf lab{1}Chan3:DigOut_Park-SP 0
dbpf lab{1}Chan4:DigOut_Park-SP 0

dbpf lab{1}Chan1:DAC_SetPt-SP 0
dbpf lab{1}Chan2:DAC_SetPt-SP 0
dbpf lab{1}Chan3:DAC_SetPt-SP 0
dbpf lab{1}Chan4:DAC_SetPt-SP 0

#dbpf lab{1}Chan1:DACSetPt-Offset-SP 0.0
#dbpf lab{1}Chan1:DACSetPt-Gain-SP 1.0

dbpf lab{1}Chan1:DAC_OpMode-SP 0
dbpf lab{1}Chan2:DAC_OpMode-SP 0
dbpf lab{1}Chan3:DAC_OpMode-SP 0
dbpf lab{1}Chan4:DAC_OpMode-SP 0

dbpf lab{1}Chan2:AveMode-SP 0


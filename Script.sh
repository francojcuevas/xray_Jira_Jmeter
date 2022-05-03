#!/bin/bash
rm results.jtl
JMETERPLUGINSCMD=JMeterPluginsCMD.sh
# run jmeter and produce a JTL csv report
rm -R dashboard/
jmeter -n -t  $WORKSPACE/hb_0324.jmx -l $WORKSPACE/results.jtl -e -o dashboard

# process JTL and covert it to a synthesis report as CSV
$JMETERPLUGINSCMD --generate-csv synthesis_results.csv --input-jtl results.jtl --plugin-type SynthesisReport
$JMETERPLUGINSCMD --tool Reporter --generate-csv reports/aggregate_results.csv --input-jtl results.jtl --plugin-type AggregateReport

$JMETERPLUGINSCMD --generate-png reports/ResponseTimesOverTime.png --input-jtl results.jtl --plugin-type ResponseTimesOverTime --width 800 --height 600
$JMETERPLUGINSCMD --generate-png reports/TransactionsPerSecond.png --input-jtl results.jtl --plugin-type TransactionsPerSecond --width 800 --height 600
java -jar $WORKSPACE/jmeter-junit-xml-converter-0.0.1-SNAPSHOT-jar-with-dependencies.jar results.jtl reporteconvertido.xml
curl -D- -X POST "https://laboratoriobfcl.atlassian.net/rest/api/3/issue/$TESTPLAN/attachments" -H 'X-Atlassian-Token: no-check' -F "file="@$WORKSPACE/alternate_reporteconvertido.xml"" -H 'application/octet-stream' -H 'Authorization: Basic a2V2aW4ucGVuYUB0c29mdGxhdGFtLmNvbTp5eVZDWWNGU2dPMkRVbk5KN3R4RTA3MjU= ' 

#!/usr/bin/env nextflow
/*
========================================================================================
    nf-core/vcreport
========================================================================================
    Github : https://github.com/nf-core/vcreport
    Website: https://nf-co.re/vcreport
    Slack  : https://nfcore.slack.com/channels/vcreport
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2




/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    NAMED WORKFLOW FOR PIPELINE
========================================================================================
*/

include { VCREPORT } from './workflows/vcreport'
include { EXECUTEREPORT } from './modules/local/executereport' addParams( options: [:] )

//
// WORKFLOW: Run main nf-core/vcreport analysis pipeline
//
workflow NFCORE_VCREPORT {
    VCREPORT ()

}

// WORKFLOW: Execute a single named workflow for the pipeline
// See: https://github.com/nf-core/rnaseq/issues/619
workflow {
    NFCORE_VCREPORT  ()
}

/*
========================================================================================
    THE END
========================================================================================
*/

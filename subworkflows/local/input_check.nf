//
// Check input samplesheet and get read channels
//

params.options = [:]

include { SAMPLESHEET_CHECK } from '../../modules/local/samplesheet_check' addParams( options: params.options )

workflow INPUT_CHECK {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    SAMPLESHEET_CHECK ( samplesheet )
        .splitCsv ( header:true, sep:',' )
        .map { create_fastq_channels(it) }
        .set { reads }

    emit:
    reads // channel: [ val(meta), [ reads ] ]
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_fastq_channels(LinkedHashMap col) {
    def meta = [:]
    meta.id           = col.sample

    def array = []
    if (!file(col.vcf).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> vcf file does not exist!\n${row.vcf}"
    }
    array = [ meta, [ file(col.vcf) ] ]
    return array
}

//
// Check input samplesheet and get read channels
//

params.options = [:]

include { BCFTOOLS_VIEW } from '../../modules/nf-core/modules/bcftools/view/main' addParams( options: params.options )
include { BCFTOOLS_INDEX } from '../../modules/nf-core/modules/bcftools/index/main' addParams( options: params.options )
include { TABIX_BGZIPTABIX } from '../../modules/nf-core/modules/tabix/bgziptabix/main' addParams( options: params.options )
include { BCFTOOLS_FILTER } from '../../modules/nf-core/modules/bcftools/filter/main' addParams( options: params.options )


workflow VCF_FILTER {
    take:
    vcf

    main:
    ch_version = Channel.empty()
    ch_vcfs = Channel.empty()
    TABIX_BGZIPTABIX ( vcf )
    //BCFTOOLS_FILTER ( vcf )
    BCFTOOLS_VIEW ( TABIX_BGZIPTABIX.out.gz_tbi , [], [], [])
    ch_version = ch_version.mix(TABIX_BGZIPTABIX.out.versions)
    ch_vcfs = BCFTOOLS_VIEW.out.vcf
    ch_version = ch_version.mix(BCFTOOLS_VIEW.out.versions)
   // ch_version = ch_version.mix(BCFTOOLS_FILTER.out.versions)


    emit:
    // channel: [ val(meta), [ vcf ] ]
    version = ch_version
    ch_vcfs
    //path "*version.txt"   , emit: versions






    }

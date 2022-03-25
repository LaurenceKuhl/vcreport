//
// Check input samplesheet and get read channels
//

params.options = [:]

include { BCFTOOLS_VIEW } from '../../modules/nf-core/modules/bcftools/view/main' addParams( options: params.options )
include { BCFTOOLS_INDEX } from '../../modules/nf-core/modules/bcftools/index/main' addParams( options: params.options )
include { TABIX_BGZIP } from '../../modules/nf-core/modules/tabix/bgzip/main' addParams( options: params.options )
include { BCFTOOLS_FILTER } from '../../modules/nf-core/modules/bcftools/filter/main' addParams( options: params.options )


workflow VCF_FILTER {
    take:
    vcf

    main:
    ch_version = Channel.empty()

    TABIX_BGZIP ( vcf )
    BCFTOOLS_INDEX( TABIX_BGZIP.out.gz )

    TABIX_BGZIP.out.gz
        .join(BCFTOOLS_INDEX.out.tbi, by: [0], remainder: true)
        .join(BCFTOOLS_INDEX.out.csi, by: [0], remainder: true)
        .map {
            meta, vcf, tbi, csi ->
                if (tbi) {
                    [ meta, vcf, tbi ]
                } else {
                    [ meta, vcf, csi ]
                }
        }
        .set { ch_vcf_tbi }

    BCFTOOLS_FILTER ( TABIX_BGZIP.out.gz )
    ch_version = ch_version.mix(TABIX_BGZIP.out.versions)
    ch_version = ch_version.mix(BCFTOOLS_INDEX.out.versions)
    ch_version = ch_version.mix(BCFTOOLS_FILTER.out.versions)


    emit:
    // channel: [ val(meta), [ vcf ] ]
    version = ch_version



    //csi = BCFTOOLS_INDEX




    }

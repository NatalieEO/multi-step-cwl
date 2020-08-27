###############################################################################################
# This workflow will align reads from a fastq file and print statistics for a SAM
# file to another file

# launch locally with Dockstore CLI:
#   dockstore workflow launch --local-entry uber_workflow_align_and_metrics.cwl --json uber_workflow_align_and_metrics.json
###############################################################################################
#
cwlVersion: v1.2

# See documentation here https://www.commonwl.org/user_guide/
# The cwlVersion field indicates the version of the CWL spec used by the document.
# The class field indicates this document describes a workflow.
class: Workflow

label: {"$include":"metadata.txt"}
#label: A workflow that aligns a fasta file and provides statistics on the SAM file
doc: A workflow that aligns a fasta file and provides statistics on the SAM file

# Metadata about the tool or workflow itself (for example, authorship for use in citations)
# may be provided as additional fields on any object
# Once you add the namespace prefix, you can access it anywhere in the document as shown
# below. Otherwise one must use full URLs.
$namespaces:
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

dct:creator:
  '@id':  https://orcid.org/0000-0001-5173-4627
  foaf:name: Walter Shands
  foaf:mbox: jshands@ucsc.edu

# Top level inputs and outputs of the workflow are described in the inputs and outputs fields respectively.

# The inputs section describes the inputs of the workflow.
# This is a list of input parameters where each parameter consists of an identifier
# and a data type.
# These parameters can be used as sources for input to specific workflows steps.
inputs:
    sample_name: string
    bwa_opt: string
    ref_fasta: File
    ref_fasta_fai: File
    ref_fasta_amb: File
    ref_fasta_ann: File
    ref_fasta_bwt: File
    ref_fasta_pac: File
    ref_fasta_sa: File
    read1_fastqs: File[]
    read2_fastqs: File[]

    metrics_requested: boolean

# The outputs section describes the outputs of the workflow. This is a list of output
# parameters where each parameter consists of an identifier and a data type.
# There are two outputs from this workflow, both are files, and one output called
# 'output_sam' is a file that is produced byt he bwa_align step.
outputs:
  output_sam:
    type: File[]
    outputSource: subworkflow_align_and_metrics/output_sam
  output_metrics:
    type: ["null", "File[]"]
    outputSource: subworkflow_align_and_metrics/output_metrics

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

# The steps section describes the actual steps of the workflow.
# Each step in a workflow must have its own CWL description.
# Workflow steps are not necessarily run in the order they are listed, instead
# the order is determined by the dependencies between steps (using source). In
# addition, workflow steps which do not depend on one another may run in parallel.
steps:
#  quality_check_not_defined_yet:
#    run:
#      class: Operation
#      inputs:
#        ref_fasta: File
#      outputs:
#        fasta_quality: File
#    in:
#      ref_fasta: ref_fasta
#    out: [fasta_quality]


  subworkflow_align_and_metrics:
    scatter: [read1_fastq, read2_fastq]
    scatterMethod: dotproduct
    run: sub_workflow_align_and_metrics.cwl
    in:
      sample_name: sample_name
      bwa_opt: bwa_opt
      ref_fasta: ref_fasta
      ref_fasta_fai: ref_fasta_fai
      ref_fasta_amb: ref_fasta_amb
      ref_fasta_ann: ref_fasta_ann
      ref_fasta_bwt: ref_fasta_bwt
      ref_fasta_pac: ref_fasta_pac
      ref_fasta_sa: ref_fasta_sa
      read1_fastq: read1_fastqs
      read2_fastq: read2_fastqs

      metrics_requested: metrics_requested

    out: [output_sam, output_metrics]


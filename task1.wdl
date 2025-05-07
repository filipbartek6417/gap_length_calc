version 1.0

workflow ProcessAssembly {
    input {
        File assembly_file
    }

    call CountGaps {
        input:
            assembly_file = assembly_file
    }

    output {
        Int total_gap_length = CountGaps.total_gap_length
    }
}

task CountGaps {
    input {
        File assembly_file
    }

    command {
        grep -o "[Nn-]+" ~{assembly_file} | tr -d '\n' | wc -m > gap_length.txt
    }

    output {
        Int total_gap_length = read_int("gap_length.txt")
    }

    runtime {
        docker: "debian:bullseye"
        memory: "1 GB"
        cpu: 1
        preemptible: true
    }
}

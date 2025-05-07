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

    command <<<
         gzip -d -c ~{assembly_file} | grep -v "^>" | grep -o -i 'N' | tr -d "\n" | wc -m > gap_length.txt
    >>>

    output {
        Int total_gap_length = read_int("gap_length.txt")
    }

    runtime {
        docker: "ubuntu:latest"
        memory: "4 GB"
        cpu: 1
        preemptible: 2
    }
}

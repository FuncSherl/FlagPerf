#!/bin/bash
#set -x

apt install -y jq
bp=$1

echo -e  "op_dtype\tflaggems_correctness\tnativetorch_correctness\tnativetorch_cpu_time(us)\tnativetorch_kernel_time(us)\tflaggems_cpu_time(us)\tflaggems_kernel_time(us)\tflaggems_tflops(tflops)\tnativetorch_tflops(tflops)"
for i in `ls $bp`;do

        dap=$bp/$i/data.json

        if [ ! -f $dap ]; then
        continue
        fi

        jstr=`sed "s/'/\"/g" $dap`

nativetorch_cpu_time=`echo $jstr | jq -r '.nativetorch_cpu_time'`
nativetorch_kernel_time=`echo $jstr | jq -r '.nativetorch_kernel_time' `

flaggems_cpu_time=`echo $jstr | jq -r '.flaggems_cpu_time' `
flaggems_kernel_time=`echo $jstr | jq -r '.flaggems_kernel_time' `

flaggems_correctness=`echo $jstr | jq -r '.flaggems_correctness' `
torch_correctness=`echo $jstr | jq -r '.nativetorch_correctness' `

flaggems_tflops=`echo $jstr | jq -r '.flaggems_tflops' `
nativetorch_tflops=`echo $jstr | jq -r '.nativetorch_tflops' `

echo -e $i"\t"${flaggems_correctness}"\t"${torch_correctness}"\t"${nativetorch_cpu_time%??}"\t"${nativetorch_kernel_time%??}"\t"${flaggems_cpu_time%??}"\t"${flaggems_kernel_time%??}"\t"${flaggems_tflops%??????}"\t"${nativetorch_tflops%??????}
done

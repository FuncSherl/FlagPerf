### Iluvatar GPU配置与运行信息参考
#### 环境配置
- ##### 硬件环境
    - 机器型号: 机器型号: R5300 G5
    - 加速卡型号: Iluvatar Bi-150
    - CPU型号:  Intel(R) Xeon(R) Platinum 8462Y+
    - 多机网络类型、带宽: InfiniBand，200Gb/s
    
- ##### 软件环境
   - OS版本：Ubuntu 20.04
   - OS kernel版本: 5.4.0-126-generic     
   - 加速卡驱动版本：4.1.0
   - Docker 版本：20.10.25
   - 训练框架版本：deepspeed 0.14.3

- ##### 并行策略

   - 并行技术：sharded data parallel
   - 实施者：deepspeed ZeRO-DP
   - 实施细节：ZeRO-DP O3

### 运行情况

* 输入批尺寸
  1. local_batchsize(micro_batchsize)，简写为LBS，即实际进入模型的张量批尺寸，为config_BI-V150x1x16.py中所写，在本case中默认为**1**
  2. seqlength(max_position_embedding)，简写为MPE，即实际进入模型的序列长度，为config_BI-V150x1x16.py中所写，在本case中默认为**2048**
  3. gradient_accumulate_steps，简写为GAS，即梯度累加步数，为ds_config.json中所写，在本case中默认为**1**
  4. global_batchsize恒等于local_batchsize\*gradient_accumulate_steps\*data_parallel_size，简写为GBS。在本case中，只存在数据并行，因此data_parallel_size=world_size。

* 通用指标

| 指标名称     | 指标值                     | 特殊说明                           |
| ------------ | -------------------------- | ---------------------------------- |
| 任务类别     | 自然语言理解               |                                    |
| 模型         | chatglm3_6b             |                                    |
| 数据集       | openwebtext                | 如无特殊说明，训练前1亿个token |
| 数据精度     | amp                        |                                    |
| 超参修改     | fix_hp,见“性能指标”        | 运行必要特殊超参，例如需要改小seqlength避免OOM |
| 硬件设备简称 | Iluvatar BI-V150                |                                    |
| 硬件存储使用 | mem,见“性能指标”           | 通常称为“显存”,单位为GiB           |
| 计算使用率 | MFU,见“性能指标”           | 参见PaLM论文定义 |
| **吞吐量**   | **token/p/s,见“性能指标”** | 平均单卡每秒处理的token数          |

* 性能指标


| 配置                 | precision  | fix_hp | token/p/s | loss  | mem   | MFU         |
| ------------------ | ---------  | ------ | --------- | ---------- | ----- | ----------- |
| BI-V150单机8卡（1x8）      | bf16       |  /   |  /  | 4.31  | 6/25 |  /  |

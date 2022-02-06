{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "upduino3",
    "graph": {
      "blocks": [
        {
          "id": "854cf72c-eca3-434c-80a9-1db95058c488",
          "type": "basic.input",
          "data": {
            "name": "ICE_CS",
            "pins": [
              {
                "index": "0",
                "name": "gpio_32",
                "value": "32"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 88
          }
        },
        {
          "id": "e0b26a52-d8e0-4c6f-92fe-61e2590bf422",
          "type": "basic.output",
          "data": {
            "name": "F_MISO",
            "pins": [
              {
                "index": "0",
                "name": "gpio_17",
                "value": "17"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1200,
            "y": 96
          }
        },
        {
          "id": "7503dafb-35ab-42f2-9c16-90b6d019244f",
          "type": "basic.output",
          "data": {
            "name": "PHV",
            "pins": [
              {
                "index": "0",
                "name": "gpio_21",
                "value": "21"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 96
          }
        },
        {
          "id": "5f1b7c11-baea-4b6c-aed8-29b3d86fa3dc",
          "type": "basic.input",
          "data": {
            "name": "F_SCLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_15",
                "value": "15"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 144
          }
        },
        {
          "id": "e99a9b94-0282-4de2-98bb-d8c82797a17e",
          "type": "basic.output",
          "data": {
            "name": "HILO",
            "pins": [
              {
                "index": "0",
                "name": "gpio_18",
                "value": "18"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1440,
            "y": 160
          }
        },
        {
          "id": "10715efa-451a-4739-9875-bb7a2593d7e6",
          "type": "basic.input",
          "data": {
            "name": "ADC_CLK",
            "range": "[9:0]",
            "pins": [
              {
                "index": "9",
                "name": "gpio_45",
                "value": "45"
              },
              {
                "index": "8",
                "name": "gpio_46",
                "value": "46"
              },
              {
                "index": "7",
                "name": "gpio_47",
                "value": "47"
              },
              {
                "index": "6",
                "name": "gpio_48",
                "value": "48"
              },
              {
                "index": "5",
                "name": "gpio_2",
                "value": "2"
              },
              {
                "index": "4",
                "name": "gpio_3",
                "value": "3"
              },
              {
                "index": "3",
                "name": "gpio_4",
                "value": "4"
              },
              {
                "index": "2",
                "name": "gpio_6",
                "value": "6"
              },
              {
                "index": "1",
                "name": "gpio_9",
                "value": "9"
              },
              {
                "index": "0",
                "name": "gpio_10",
                "value": "10"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 408,
            "y": 168
          }
        },
        {
          "id": "1fe4900d-fd18-4d05-b8b2-3ac13aa088f4",
          "type": "basic.output",
          "data": {
            "name": "PnHV",
            "pins": [
              {
                "index": "0",
                "name": "gpio_20",
                "value": "20"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 168
          }
        },
        {
          "id": "9bccd4fc-8396-42d4-ac36-2d78a07d7457",
          "type": "basic.input",
          "data": {
            "name": "F_MOSI",
            "pins": [
              {
                "index": "0",
                "name": "gpio_14",
                "value": "14"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 208
          }
        },
        {
          "id": "e622ee99-88f5-4378-9f56-0201173bf4a1",
          "type": "basic.output",
          "data": {
            "name": "HV_EN",
            "pins": [
              {
                "index": "0",
                "name": "gpio_34",
                "value": "34"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1448,
            "y": 224
          }
        },
        {
          "id": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a",
          "type": "basic.input",
          "data": {
            "name": "RST",
            "pins": [
              {
                "index": "0",
                "name": "gpio_26",
                "value": "26"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 272
          }
        },
        {
          "id": "1318e52a-b44b-4493-8a9d-5fe0f7c553f1",
          "type": "basic.output",
          "data": {
            "name": "Pdamp",
            "pins": [
              {
                "index": "0",
                "name": "gpio_19",
                "value": "19"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 272
          }
        },
        {
          "id": "fb576a67-8424-4fc0-93fe-0c4932fb7b6a",
          "type": "basic.output",
          "data": {
            "name": "ADC_CLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_37",
                "value": "37"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1456,
            "y": 288
          }
        },
        {
          "id": "9b6eb3ac-2b5f-4c20-b691-6d08476cc561",
          "type": "basic.output",
          "data": {
            "name": "DAC_SCLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_12",
                "value": "12"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 360
          }
        },
        {
          "id": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
          "type": "basic.input",
          "data": {
            "name": "DCLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_44",
                "value": "44"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 368
          }
        },
        {
          "id": "a471f67f-71bc-4738-8b6f-9a3f25e7d606",
          "type": "basic.output",
          "data": {
            "name": "RGB",
            "range": "[2:0]",
            "pins": [
              {
                "index": "2",
                "name": "led_red",
                "value": "41"
              },
              {
                "index": "1",
                "name": "led_green",
                "value": "39"
              },
              {
                "index": "0",
                "name": "led_blue",
                "value": "40"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1456,
            "y": 384
          }
        },
        {
          "id": "60c881ea-0572-4a65-85ae-b828f731a4e2",
          "type": "basic.input",
          "data": {
            "name": "TOP_T1",
            "pins": [
              {
                "index": "0",
                "name": "gpio_23",
                "value": "23"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 432
          }
        },
        {
          "id": "8fb648dc-b448-413e-aaad-539222792ed4",
          "type": "basic.output",
          "data": {
            "name": "DAC_CS",
            "pins": [
              {
                "index": "0",
                "name": "gpio_13",
                "value": "13"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 456
          }
        },
        {
          "id": "d8905bb3-e5d4-4758-883b-c0231d43be5f",
          "type": "basic.input",
          "data": {
            "name": "TOP_T2",
            "pins": [
              {
                "index": "0",
                "name": "gpio_25",
                "value": "25"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 568,
            "y": 496
          }
        },
        {
          "id": "198b8027-b69a-40f1-9e64-9b89e66d11e6",
          "type": "basic.output",
          "data": {
            "name": "DAC_MOSI",
            "pins": [
              {
                "index": "0",
                "name": "gpio_11",
                "value": "11"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1312,
            "y": 512
          }
        },
        {
          "id": "70c88a81-6179-4b5d-8bb7-87e57b21bef9",
          "type": "basic.output",
          "data": {
            "name": "EA_CLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_36",
                "value": "36"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1456,
            "y": 520
          }
        },
        {
          "id": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
          "type": "basic.code",
          "data": {
            "code": "// @include spi_slave.v\r\n spi_slave spi_uut(\r\n.rstb(!RST),.ten(1'b1),\r\n.mlb(1'b1),.ss(ICE_CS),\r\n.sck(F_SCLK),.sdin(F_MOSI),\r\n.sdout(F_MISO),.tdata(to_spi),\r\n.done(spi_strb),.rdata(from_spi));",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "ICE_CS"
                },
                {
                  "name": "F_SCLK"
                },
                {
                  "name": "F_MOSI"
                },
                {
                  "name": "to_spi",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "RST"
                }
              ],
              "out": [
                {
                  "name": "F_MISO"
                },
                {
                  "name": "from_spi",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "spi_strb"
                }
              ]
            }
          },
          "position": {
            "x": 792,
            "y": 104
          },
          "size": {
            "width": 352,
            "height": 152
          }
        },
        {
          "id": "47479a02-c875-4b11-abaa-d960aaaccf08",
          "type": "basic.code",
          "data": {
            "code": "// @include adc_dac_pulser.v\n// @include mcp4812.v\n\nadc_dac_pulser pulsar_uut(\n .RST      (RST     ),\n .DCLK     (DCLK    ),\n .ADC_DATA (ADC_DATA),\n .HILO     (HILO    ),\n .HV_EN    (HV_EN   ),\n .TOP_T1   (TOP_T1  ),\n .TOP_T2   (TOP_T2  ),\n .EA_CLK   (EA_CLK  ),\n .PHV      (PHV     ),\n .PnHV     (PnHV    ),\n .Pdamp    (Pdamp   ),\n .ADC_CLK  (ADC_CLK ),\n .DAC_SCLK (DAC_SCLK),\n .DAC_CS   (DAC_CS  ),\n .DAC_MOSI (DAC_MOSI),\n .spi_strb (spi_strb),\n .to_spi   (to_spi  ),\n .from_spi (from_spi),\n .RGB      (RGB     ));",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "RST"
                },
                {
                  "name": "DCLK"
                },
                {
                  "name": "ADC_DATA",
                  "range": "[9:0]",
                  "size": 10
                },
                {
                  "name": "TOP_T1"
                },
                {
                  "name": "TOP_T2"
                },
                {
                  "name": "from_spi",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "spi_strb"
                }
              ],
              "out": [
                {
                  "name": "PHV"
                },
                {
                  "name": "PnHV"
                },
                {
                  "name": "Pdamp"
                },
                {
                  "name": "HILO"
                },
                {
                  "name": "HV_EN"
                },
                {
                  "name": "ADC_CLK"
                },
                {
                  "name": "DAC_SCLK"
                },
                {
                  "name": "DAC_CS"
                },
                {
                  "name": "DAC_MOSI"
                },
                {
                  "name": "to_spi",
                  "range": "[7:0]",
                  "size": 8
                },
                {
                  "name": "RGB",
                  "range": "[2:0]",
                  "size": 3
                },
                {
                  "name": "EA_CLK"
                }
              ]
            }
          },
          "position": {
            "x": 808,
            "y": 312
          },
          "size": {
            "width": 344,
            "height": 256
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "854cf72c-eca3-434c-80a9-1db95058c488",
            "port": "out"
          },
          "target": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "ICE_CS"
          }
        },
        {
          "source": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "F_MISO"
          },
          "target": {
            "block": "e0b26a52-d8e0-4c6f-92fe-61e2590bf422",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "9bccd4fc-8396-42d4-ac36-2d78a07d7457",
            "port": "out"
          },
          "target": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "F_MOSI"
          }
        },
        {
          "source": {
            "block": "5f1b7c11-baea-4b6c-aed8-29b3d86fa3dc",
            "port": "out"
          },
          "target": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "F_SCLK"
          }
        },
        {
          "source": {
            "block": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a",
            "port": "out"
          },
          "target": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "RST"
          }
        },
        {
          "source": {
            "block": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a",
            "port": "out"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "RST"
          }
        },
        {
          "source": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "spi_strb"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "spi_strb"
          },
          "vertices": [
            {
              "x": 1240,
              "y": 552
            }
          ]
        },
        {
          "source": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "from_spi"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "from_spi"
          },
          "size": 8
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "to_spi"
          },
          "target": {
            "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
            "port": "to_spi"
          },
          "size": 8
        },
        {
          "source": {
            "block": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
            "port": "out"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "DCLK"
          },
          "vertices": [
            {
              "x": 680,
              "y": 360
            }
          ]
        },
        {
          "source": {
            "block": "10715efa-451a-4739-9875-bb7a2593d7e6",
            "port": "out"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "ADC_DATA"
          },
          "vertices": [
            {
              "x": 672,
              "y": 360
            }
          ],
          "size": 10
        },
        {
          "source": {
            "block": "60c881ea-0572-4a65-85ae-b828f731a4e2",
            "port": "out"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "TOP_T1"
          },
          "vertices": [
            {
              "x": 712,
              "y": 448
            }
          ]
        },
        {
          "source": {
            "block": "d8905bb3-e5d4-4758-883b-c0231d43be5f",
            "port": "out"
          },
          "target": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "TOP_T2"
          }
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "Pdamp"
          },
          "target": {
            "block": "1318e52a-b44b-4493-8a9d-5fe0f7c553f1",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1264,
              "y": 336
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "PHV"
          },
          "target": {
            "block": "7503dafb-35ab-42f2-9c16-90b6d019244f",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1248,
              "y": 248
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "PnHV"
          },
          "target": {
            "block": "1fe4900d-fd18-4d05-b8b2-3ac13aa088f4",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1256,
              "y": 272
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "DAC_CS"
          },
          "target": {
            "block": "8fb648dc-b448-413e-aaad-539222792ed4",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "DAC_MOSI"
          },
          "target": {
            "block": "198b8027-b69a-40f1-9e64-9b89e66d11e6",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "DAC_SCLK"
          },
          "target": {
            "block": "9b6eb3ac-2b5f-4c20-b691-6d08476cc561",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "RGB"
          },
          "target": {
            "block": "a471f67f-71bc-4738-8b6f-9a3f25e7d606",
            "port": "in"
          },
          "size": 3
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "HILO"
          },
          "target": {
            "block": "e99a9b94-0282-4de2-98bb-d8c82797a17e",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1408,
              "y": 344
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "HV_EN"
          },
          "target": {
            "block": "e622ee99-88f5-4378-9f56-0201173bf4a1",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1272,
              "y": 384
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "ADC_CLK"
          },
          "target": {
            "block": "fb576a67-8424-4fc0-93fe-0c4932fb7b6a",
            "port": "in"
          },
          "vertices": [
            {
              "x": 1416,
              "y": 384
            }
          ]
        },
        {
          "source": {
            "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
            "port": "EA_CLK"
          },
          "target": {
            "block": "70c88a81-6179-4b5d-8bb7-87e57b21bef9",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
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
          "id": "a576687d-482b-4454-9cc0-ad6a9fa035ce",
          "type": "basic.input",
          "data": {
            "name": "RCLK",
            "pins": [
              {
                "index": "0",
                "name": "gpio_35",
                "value": "35"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": -288
          }
        },
        {
          "id": "80f9a9dc-c218-45e3-989e-84ba487cd731",
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
            "x": 1136,
            "y": -280
          }
        },
        {
          "id": "49da63ed-a2f5-4dc3-b8a4-00c5f8d75636",
          "type": "basic.input",
          "data": {
            "name": "BT_USER",
            "pins": [
              {
                "index": "0",
                "name": "gpio_38",
                "value": "38"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": -224
          }
        },
        {
          "id": "74dba231-5c52-4ffe-9b2a-dd555f6da01e",
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
            "x": 1136,
            "y": -160
          }
        },
        {
          "id": "44fe377a-be2f-4020-8c1f-33a95e84177b",
          "type": "basic.input",
          "data": {
            "name": "BT_TRIG",
            "pins": [
              {
                "index": "0",
                "name": "gpio_31",
                "value": "31"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": -128
          }
        },
        {
          "id": "526c195f-e77e-46fb-9315-871210c55690",
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
            "x": 24,
            "y": -32
          }
        },
        {
          "id": "d20195d1-4bb2-4cd4-a846-f76d2dec77d2",
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
            "x": 1136,
            "y": -32
          }
        },
        {
          "id": "840ffd8a-fcd5-4aca-81bd-dd0279de75e4",
          "type": "basic.input",
          "data": {
            "name": "ADC_DATA",
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
            "x": 24,
            "y": 32
          }
        },
        {
          "id": "00f0f9d9-f3b7-483c-af73-4367ec3d3f23",
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
            "x": 1136,
            "y": 96
          }
        },
        {
          "id": "31c77238-d076-46a5-97b6-419357531251",
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
            "x": 1136,
            "y": 216
          }
        },
        {
          "id": "a5df8790-dab9-4b89-b27c-d633e1cc7d52",
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
            "x": 1144,
            "y": 344
          }
        },
        {
          "id": "de642665-b78f-41a1-862e-06e9901fdb34",
          "type": "basic.input",
          "data": {
            "name": "HILO",
            "pins": [
              {
                "index": "0",
                "name": "gpio_18",
                "value": "18"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": 416
          }
        },
        {
          "id": "0c95cd8d-4b8d-47b0-af00-c8f325f2f0a8",
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
            "x": 1136,
            "y": 472
          }
        },
        {
          "id": "7f488a0a-4dc9-4445-9283-c345107fa683",
          "type": "basic.input",
          "data": {
            "name": "HV_EN",
            "pins": [
              {
                "index": "0",
                "name": "gpio_34",
                "value": "34"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": 480
          }
        },
        {
          "id": "00b67da6-9ca6-40bc-b24f-3097513c2088",
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
            "x": 24,
            "y": 544
          }
        },
        {
          "id": "070374fa-f478-4a3b-8650-c476f6705153",
          "type": "basic.output",
          "data": {
            "name": "F_MISO",
            "pins": [
              {
                "index": "0",
                "name": "gpio_14",
                "value": "14"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1144,
            "y": 592
          }
        },
        {
          "id": "b9b9008b-2616-4b03-a481-7c99ff789f70",
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
            "x": 24,
            "y": 632
          }
        },
        {
          "id": "f0402a80-5ae9-4045-bea8-178a013db04d",
          "type": "basic.output",
          "data": {
            "name": "Lred",
            "pins": [
              {
                "index": "0",
                "name": "led_red",
                "value": "41"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1144,
            "y": 720
          }
        },
        {
          "id": "70b47ec7-8e27-4a75-a3a5-33258bcfb7f1",
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
            "x": 24,
            "y": 744
          }
        },
        {
          "id": "bf28b722-28d9-478d-869e-88e60a75d3d6",
          "type": "basic.output",
          "data": {
            "name": "Lgreen",
            "pins": [
              {
                "index": "0",
                "name": "led_green",
                "value": "39"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1144,
            "y": 848
          }
        },
        {
          "id": "2dcd64df-481e-4ae0-8d6a-0c47c5ddd2dc",
          "type": "basic.input",
          "data": {
            "name": "F_MOSI",
            "pins": [
              {
                "index": "0",
                "name": "gpio_17",
                "value": "17"
              }
            ],
            "virtual": false,
            "clock": false
          },
          "position": {
            "x": 24,
            "y": 864
          }
        },
        {
          "id": "651fbc48-bf45-4460-969e-dd7cb6286de5",
          "type": "basic.output",
          "data": {
            "name": "Lblue",
            "pins": [
              {
                "index": "0",
                "name": "led_blue",
                "value": "40"
              }
            ],
            "virtual": false
          },
          "position": {
            "x": 1144,
            "y": 968
          }
        },
        {
          "id": "e0025bfc-902c-499d-974d-ff4e8ed9f8c2",
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
            "x": 24,
            "y": 976
          }
        },
        {
          "id": "2a656d3c-703d-4dbe-96af-0cd8df055099",
          "type": "basic.code",
          "data": {
            "code": "\r\n// @include adc_dac_pulser_top.v\r\n// @include up5kPLL.v\r\n// @include mcp4812.v\r\n// @include spi_slave.v\r\n\r\n//F_SCLK, F_MOSI, F_MISO pin assignments are nmanually edited !!!\r\n\r\nadc_dac_pulser_top pulsar_uut(\r\nRCLK,\r\nBT_USER,\r\nBT_TRIG,\r\nDCLK,\r\nADC_DATA,\r\nHILO,\r\nHV_EN,\r\nTOP_T1,\r\nTOP_T2,\r\nF_SCLK,\r\nF_MOSI,\r\nICE_CS,\r\nPHV,\r\nPnHV,\r\nPdamp,\r\nADC_CLK,\r\nDAC_SCLK,\r\nDAC_CS,\r\nDAC_MOSI,\r\nF_MISO,\r\nLred,\r\nLgreen,\r\nLblue);\r\n",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "RCLK"
                },
                {
                  "name": "BT_USER"
                },
                {
                  "name": "BT_TRIG"
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
                  "name": "HILO"
                },
                {
                  "name": "HV_EN"
                },
                {
                  "name": "TOP_T1"
                },
                {
                  "name": "TOP_T2"
                },
                {
                  "name": "F_SCLK"
                },
                {
                  "name": "F_MOSI"
                },
                {
                  "name": "ICE_CS"
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
                  "name": "F_MISO"
                },
                {
                  "name": "Lred"
                },
                {
                  "name": "Lgreen"
                },
                {
                  "name": "Lblue"
                }
              ]
            }
          },
          "position": {
            "x": 344,
            "y": -312
          },
          "size": {
            "width": 688,
            "height": 1376
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "a576687d-482b-4454-9cc0-ad6a9fa035ce",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "RCLK"
          }
        },
        {
          "source": {
            "block": "526c195f-e77e-46fb-9315-871210c55690",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "DCLK"
          }
        },
        {
          "source": {
            "block": "840ffd8a-fcd5-4aca-81bd-dd0279de75e4",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "ADC_DATA"
          },
          "size": 10
        },
        {
          "source": {
            "block": "de642665-b78f-41a1-862e-06e9901fdb34",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "HILO"
          },
          "vertices": [
            {
              "x": 152,
              "y": 432
            }
          ]
        },
        {
          "source": {
            "block": "7f488a0a-4dc9-4445-9283-c345107fa683",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "HV_EN"
          },
          "vertices": [
            {
              "x": 176,
              "y": 480
            }
          ]
        },
        {
          "source": {
            "block": "00b67da6-9ca6-40bc-b24f-3097513c2088",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "TOP_T1"
          },
          "vertices": []
        },
        {
          "source": {
            "block": "b9b9008b-2616-4b03-a481-7c99ff789f70",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "TOP_T2"
          },
          "vertices": [
            {
              "x": 208,
              "y": 664
            }
          ]
        },
        {
          "source": {
            "block": "70b47ec7-8e27-4a75-a3a5-33258bcfb7f1",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "F_SCLK"
          }
        },
        {
          "source": {
            "block": "2dcd64df-481e-4ae0-8d6a-0c47c5ddd2dc",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "F_MOSI"
          }
        },
        {
          "source": {
            "block": "e0025bfc-902c-499d-974d-ff4e8ed9f8c2",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "ICE_CS"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "ADC_CLK"
          },
          "target": {
            "block": "00f0f9d9-f3b7-483c-af73-4367ec3d3f23",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "DAC_SCLK"
          },
          "target": {
            "block": "31c77238-d076-46a5-97b6-419357531251",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "Lred"
          },
          "target": {
            "block": "f0402a80-5ae9-4045-bea8-178a013db04d",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "Lgreen"
          },
          "target": {
            "block": "bf28b722-28d9-478d-869e-88e60a75d3d6",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "DAC_CS"
          },
          "target": {
            "block": "a5df8790-dab9-4b89-b27c-d633e1cc7d52",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "DAC_MOSI"
          },
          "target": {
            "block": "0c95cd8d-4b8d-47b0-af00-c8f325f2f0a8",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "F_MISO"
          },
          "target": {
            "block": "070374fa-f478-4a3b-8650-c476f6705153",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "PHV"
          },
          "target": {
            "block": "80f9a9dc-c218-45e3-989e-84ba487cd731",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "PnHV"
          },
          "target": {
            "block": "74dba231-5c52-4ffe-9b2a-dd555f6da01e",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "Pdamp"
          },
          "target": {
            "block": "d20195d1-4bb2-4cd4-a846-f76d2dec77d2",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "49da63ed-a2f5-4dc3-b8a4-00c5f8d75636",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "BT_USER"
          }
        },
        {
          "source": {
            "block": "44fe377a-be2f-4020-8c1f-33a95e84177b",
            "port": "out"
          },
          "target": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "BT_TRIG"
          }
        },
        {
          "source": {
            "block": "2a656d3c-703d-4dbe-96af-0cd8df055099",
            "port": "Lblue"
          },
          "target": {
            "block": "651fbc48-bf45-4460-969e-dd7cb6286de5",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
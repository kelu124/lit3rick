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
          "id": "88d91957-4da1-460a-9178-d1bf8c313fec",
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
            "x": -192,
            "y": -640
          }
        },
        {
          "id": "b24b83d0-e671-4a96-a240-10336025f20f",
          "type": "basic.outputLabel",
          "data": {
            "blockColor": "indianred",
            "name": "RST",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "oldBlockColor": "fuchsia"
          },
          "position": {
            "x": -80,
            "y": -608
          }
        },
        {
          "id": "e80a7c10-3e97-4a98-9dfb-f5d3d67509a9",
          "type": "basic.outputLabel",
          "data": {
            "blockColor": "darkorange",
            "name": "DCLK",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "oldBlockColor": "fuchsia"
          },
          "position": {
            "x": -80,
            "y": -536
          }
        },
        {
          "id": "ef557628-aae4-4280-afc1-b45575e407d9",
          "type": "basic.inputLabel",
          "data": {
            "blockColor": "darkorange",
            "name": "DCLK",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "oldBlockColor": "mediumvioletred"
          },
          "position": {
            "x": -600,
            "y": -504
          }
        },
        {
          "id": "ab9bfddd-8a9c-44ff-b11e-66ff67ea7ab8",
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
            "x": -352,
            "y": -496
          }
        },
        {
          "id": "c4cb73f2-bccc-4d16-aa36-0853c244785b",
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
            "x": 376,
            "y": -488
          }
        },
        {
          "id": "849ce2b4-d3bb-4e11-93b3-4ff35fb3ecf9",
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
            "x": -832,
            "y": -464
          }
        },
        {
          "id": "aad86e68-3338-4178-b0a3-2225b568823d",
          "type": "basic.inputLabel",
          "data": {
            "blockColor": "indianred",
            "name": "RST",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "oldBlockColor": "fuchsia"
          },
          "position": {
            "x": -1272,
            "y": -448
          }
        },
        {
          "id": "72917092-36fa-4178-8f5a-a734651818e0",
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
            "x": -1520,
            "y": -432
          }
        },
        {
          "id": "7d0ff0b8-34a2-47a6-80ae-8023e3c51291",
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
            "x": -352,
            "y": -424
          }
        },
        {
          "id": "c5fd6aa4-dba7-4897-a11e-21abb12d6d9d",
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
            "x": 376,
            "y": -424
          }
        },
        {
          "id": "93b158f3-9f36-44da-89f5-8acfe88c7f5d",
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
            "x": 512,
            "y": -416
          }
        },
        {
          "id": "0d77075d-aab6-4aea-aa17-4e0136951f0b",
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
            "x": -80,
            "y": -400
          }
        },
        {
          "id": "4c4f5bfb-98c8-4c91-b3b6-a476684968a1",
          "type": "basic.outputLabel",
          "data": {
            "blockColor": "darkorange",
            "name": "DCLK",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true,
            "oldBlockColor": "fuchsia"
          },
          "position": {
            "x": -1016,
            "y": -376
          }
        },
        {
          "id": "78b4914b-3805-4845-9038-36f4e8da6998",
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
            "x": -1520,
            "y": -352
          }
        },
        {
          "id": "c44df7c8-c40d-4195-8925-9bf657203796",
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
            "x": -1144,
            "y": -352
          }
        },
        {
          "id": "08b9b960-ddd6-4537-9c73-a685eae7d084",
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
            "x": -352,
            "y": -352
          }
        },
        {
          "id": "e5e6b71b-1f6c-4426-a606-4a16feba0053",
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
            "x": -80,
            "y": -344
          }
        },
        {
          "id": "f3cdbe3c-3e86-42a6-b9a7-4469b1c33cab",
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
            "x": 376,
            "y": -336
          }
        },
        {
          "id": "e61176ad-ad72-439b-a3dc-297eb42e0900",
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
            "x": 672,
            "y": -296
          }
        },
        {
          "id": "796e477b-893d-4359-bbd4-82194f6ebff6",
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
            "x": -1520,
            "y": -288
          }
        },
        {
          "id": "03142642-11d4-4ff6-a8d1-b4849d0d6d5c",
          "type": "basic.inputLabel",
          "data": {
            "blockColor": "fuchsia",
            "name": "adc_rd_data",
            "range": "[15:0]",
            "pins": [
              {
                "index": "15",
                "name": "",
                "value": ""
              },
              {
                "index": "14",
                "name": "",
                "value": ""
              },
              {
                "index": "13",
                "name": "",
                "value": ""
              },
              {
                "index": "12",
                "name": "",
                "value": ""
              },
              {
                "index": "11",
                "name": "",
                "value": ""
              },
              {
                "index": "10",
                "name": "",
                "value": ""
              },
              {
                "index": "9",
                "name": "",
                "value": ""
              },
              {
                "index": "8",
                "name": "",
                "value": ""
              },
              {
                "index": "7",
                "name": "",
                "value": ""
              },
              {
                "index": "6",
                "name": "",
                "value": ""
              },
              {
                "index": "5",
                "name": "",
                "value": ""
              },
              {
                "index": "4",
                "name": "",
                "value": ""
              },
              {
                "index": "3",
                "name": "",
                "value": ""
              },
              {
                "index": "2",
                "name": "",
                "value": ""
              },
              {
                "index": "1",
                "name": "",
                "value": ""
              },
              {
                "index": "0",
                "name": "",
                "value": ""
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 376,
            "y": -280
          }
        },
        {
          "id": "f1d905cc-b52b-4c4d-acb4-1507d005a40b",
          "type": "basic.outputLabel",
          "data": {
            "blockColor": "darkorange",
            "name": "DCLK",
            "pins": [
              {
                "index": "0",
                "name": "NULL",
                "value": "NULL"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 360,
            "y": -232
          }
        },
        {
          "id": "d0527b5f-c009-4f80-8da3-b6ec8a027a31",
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
            "x": 672,
            "y": -224
          }
        },
        {
          "id": "d0ac1481-9d8e-4acc-b1d1-cfa5154487ee",
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
            "x": -1520,
            "y": -224
          }
        },
        {
          "id": "729bb2ac-6320-44e5-ba71-2aec0ed72050",
          "type": "basic.outputLabel",
          "data": {
            "blockColor": "fuchsia",
            "name": "adc_rd_data",
            "range": "[15:0]",
            "pins": [
              {
                "index": "15",
                "name": "",
                "value": ""
              },
              {
                "index": "14",
                "name": "",
                "value": ""
              },
              {
                "index": "13",
                "name": "",
                "value": ""
              },
              {
                "index": "12",
                "name": "",
                "value": ""
              },
              {
                "index": "11",
                "name": "",
                "value": ""
              },
              {
                "index": "10",
                "name": "",
                "value": ""
              },
              {
                "index": "9",
                "name": "",
                "value": ""
              },
              {
                "index": "8",
                "name": "",
                "value": ""
              },
              {
                "index": "7",
                "name": "",
                "value": ""
              },
              {
                "index": "6",
                "name": "",
                "value": ""
              },
              {
                "index": "5",
                "name": "",
                "value": ""
              },
              {
                "index": "4",
                "name": "",
                "value": ""
              },
              {
                "index": "3",
                "name": "",
                "value": ""
              },
              {
                "index": "2",
                "name": "",
                "value": ""
              },
              {
                "index": "1",
                "name": "",
                "value": ""
              },
              {
                "index": "0",
                "name": "",
                "value": ""
              }
            ],
            "virtual": true
          },
          "position": {
            "x": -1080,
            "y": -216
          }
        },
        {
          "id": "0dc3afc2-f7d9-49e2-9f0f-82328ca8c611",
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
            "x": -672,
            "y": -208
          }
        },
        {
          "id": "b9e51af4-9c6a-48ae-a04f-5ed0b7194c9e",
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
            "x": 672,
            "y": -152
          }
        },
        {
          "id": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
          "type": "e9f5290f42a14ebe55607c33a03efea33bba5ff8",
          "position": {
            "x": 136,
            "y": -456
          },
          "size": {
            "width": 96,
            "height": 256
          }
        },
        {
          "id": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
          "type": "447f87312c479a7a8dd41c27446b6230f2da8465",
          "position": {
            "x": -1304,
            "y": -344
          },
          "size": {
            "width": 96,
            "height": 160
          }
        },
        {
          "id": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
          "type": "9af2a46e9d6a2785394cf99b1c1a1ef16e4fe0b9",
          "position": {
            "x": -568,
            "y": -424
          },
          "size": {
            "width": 96,
            "height": 128
          }
        },
        {
          "id": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
          "type": "014e8276d880bc58cf670b2e4e6dd4f6742a6667",
          "position": {
            "x": 504,
            "y": -224
          },
          "size": {
            "width": 96,
            "height": 96
          }
        },
        {
          "id": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
          "type": "fa63e7d4e7a5fa2bb234c1e95c5be6e897392d39",
          "position": {
            "x": -864,
            "y": -360
          },
          "size": {
            "width": 96,
            "height": 192
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "7e7444d4-8e6e-404b-9f13-85c39c880027"
          },
          "target": {
            "block": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
            "port": "4264b6f3-d5a8-45b1-bd3b-ad8103fe054d"
          },
          "size": 13
        },
        {
          "source": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "9a61d6c1-881c-4604-82b0-1b18716de30e"
          },
          "target": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "44233d4d-a707-4c10-9d0f-afa604106b4f"
          },
          "size": 8
        },
        {
          "source": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "4ee174eb-5f39-43e0-b4cd-a2250fb6eef0"
          },
          "target": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "a49f5dec-518f-41f1-b55d-54313d15b85a"
          }
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "53212cc3-896c-4536-a049-678713014b85"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "1231be17-22e5-4c6c-b663-6cb0f1d40b49"
          }
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "88bb51e0-e6fd-4b61-93c7-f0dffd168b5f"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "068747cf-63be-4e98-b340-e3535a3d1105"
          },
          "vertices": [],
          "size": 13
        },
        {
          "source": {
            "block": "729bb2ac-6320-44e5-ba71-2aec0ed72050",
            "port": "outlabel"
          },
          "target": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "c7aef478-81c1-46e5-8540-4229b335b23c"
          },
          "size": 16
        },
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "be4a4edb-5cef-4720-bede-3b751b50c7fd"
          },
          "target": {
            "block": "03142642-11d4-4ff6-a8d1-b4849d0d6d5c",
            "port": "inlabel"
          },
          "size": 16
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "a9f2add9-6d4e-43c6-bfb5-2a13f4ddf179"
          },
          "target": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "73f03e36-f316-48bd-8aba-a40c057fb00f"
          },
          "size": 16
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "a06bd8b6-abf9-4c86-bf78-b423d8d6d1c7"
          },
          "target": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "b43084c9-33c8-4a3a-8d93-b6d46985a664"
          }
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "9abfeb3d-dc5f-45c7-b5c9-245706e6335f"
          },
          "target": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "f08dc332-ba74-4b0e-9efb-cdb1619b3a05"
          },
          "size": 8
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "e99a9b94-0282-4de2-98bb-d8c82797a17e"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "f0a21c67-b135-4eb5-b5f2-a911eab1190b"
          }
        },
        {
          "source": {
            "block": "78b4914b-3805-4845-9038-36f4e8da6998",
            "port": "out"
          },
          "target": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "854cf72c-eca3-434c-80a9-1db95058c488"
          }
        },
        {
          "source": {
            "block": "796e477b-893d-4359-bbd4-82194f6ebff6",
            "port": "out"
          },
          "target": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "5f1b7c11-baea-4b6c-aed8-29b3d86fa3dc"
          }
        },
        {
          "source": {
            "block": "d0ac1481-9d8e-4acc-b1d1-cfa5154487ee",
            "port": "out"
          },
          "target": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "9bccd4fc-8396-42d4-ac36-2d78a07d7457"
          }
        },
        {
          "source": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "e0b26a52-d8e0-4c6f-92fe-61e2590bf422"
          },
          "target": {
            "block": "c44df7c8-c40d-4195-8925-9bf657203796",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "72917092-36fa-4178-8f5a-a734651818e0",
            "port": "out"
          },
          "target": {
            "block": "14ae7cc7-0cd5-40df-a3d8-a300e31c0b43",
            "port": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a"
          }
        },
        {
          "source": {
            "block": "0d77075d-aab6-4aea-aa17-4e0136951f0b",
            "port": "out"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "60c881ea-0572-4a65-85ae-b828f731a4e2"
          }
        },
        {
          "source": {
            "block": "e5e6b71b-1f6c-4426-a606-4a16feba0053",
            "port": "out"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "d8905bb3-e5d4-4758-883b-c0231d43be5f"
          }
        },
        {
          "source": {
            "block": "88d91957-4da1-460a-9178-d1bf8c313fec",
            "port": "out"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "10715efa-451a-4739-9875-bb7a2593d7e6"
          },
          "size": 10
        },
        {
          "source": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "05780fc6-f779-4604-b2b3-c9ae3664ffe3"
          },
          "target": {
            "block": "ab9bfddd-8a9c-44ff-b11e-66ff67ea7ab8",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "e5a9ed3b-8da6-42ac-b17d-c9c9771909a6"
          },
          "target": {
            "block": "7d0ff0b8-34a2-47a6-80ae-8023e3c51291",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "89b9b13f-de9e-4ee7-8900-b16186970d8a"
          },
          "target": {
            "block": "08b9b960-ddd6-4537-9c73-a685eae7d084",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "70c88a81-6179-4b5d-8bb7-87e57b21bef9"
          },
          "target": {
            "block": "f3cdbe3c-3e86-42a6-b9a7-4469b1c33cab",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "a471f67f-71bc-4738-8b6f-9a3f25e7d606"
          },
          "target": {
            "block": "93b158f3-9f36-44da-89f5-8acfe88c7f5d",
            "port": "in"
          },
          "size": 3
        },
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "fb576a67-8424-4fc0-93fe-0c4932fb7b6a"
          },
          "target": {
            "block": "c5fd6aa4-dba7-4897-a11e-21abb12d6d9d",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "e622ee99-88f5-4378-9f56-0201173bf4a1"
          },
          "target": {
            "block": "c4cb73f2-bccc-4d16-aa36-0853c244785b",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "e99a9b94-0282-4de2-98bb-d8c82797a17e"
          },
          "target": {
            "block": "0dc3afc2-f7d9-49e2-9f0f-82328ca8c611",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
            "port": "1fe4900d-fd18-4d05-b8b2-3ac13aa088f4"
          },
          "target": {
            "block": "d0527b5f-c009-4f80-8da3-b6ec8a027a31",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
            "port": "7503dafb-35ab-42f2-9c16-90b6d019244f"
          },
          "target": {
            "block": "e61176ad-ad72-439b-a3dc-297eb42e0900",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
            "port": "1318e52a-b44b-4493-8a9d-5fe0f7c553f1"
          },
          "target": {
            "block": "b9e51af4-9c6a-48ae-a04f-5ed0b7194c9e",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "849ce2b4-d3bb-4e11-93b3-4ff35fb3ecf9",
            "port": "out"
          },
          "target": {
            "block": "ef557628-aae4-4280-afc1-b45575e407d9",
            "port": "inlabel"
          }
        },
        {
          "source": {
            "block": "849ce2b4-d3bb-4e11-93b3-4ff35fb3ecf9",
            "port": "out"
          },
          "target": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "40aba9de-15d7-476d-aca0-a628b90fcf13"
          }
        },
        {
          "source": {
            "block": "e80a7c10-3e97-4a98-9dfb-f5d3d67509a9",
            "port": "outlabel"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "0d45c6d8-c637-4f79-93e4-83384237bb8d"
          }
        },
        {
          "source": {
            "block": "72917092-36fa-4178-8f5a-a734651818e0",
            "port": "out"
          },
          "target": {
            "block": "aad86e68-3338-4178-b0a3-2225b568823d",
            "port": "inlabel"
          }
        },
        {
          "source": {
            "block": "b24b83d0-e671-4a96-a240-10336025f20f",
            "port": "outlabel"
          },
          "target": {
            "block": "689a81e5-e76f-42e7-a799-3e0e38f2c6fe",
            "port": "b5cc20d2-70d5-43ff-a0ce-e9e2bb207537"
          }
        },
        {
          "source": {
            "block": "72917092-36fa-4178-8f5a-a734651818e0",
            "port": "out"
          },
          "target": {
            "block": "f8197cd4-e670-41dc-9e07-b0b75ec215c3",
            "port": "2591ea2f-06b8-4242-ab5a-feb0ff0bb894"
          }
        },
        {
          "source": {
            "block": "f1d905cc-b52b-4c4d-acb4-1507d005a40b",
            "port": "outlabel"
          },
          "target": {
            "block": "e6252a66-fbf7-4378-87db-7e8cebf0dfa3",
            "port": "0d45c6d8-c637-4f79-93e4-83384237bb8d"
          }
        },
        {
          "source": {
            "block": "72917092-36fa-4178-8f5a-a734651818e0",
            "port": "out"
          },
          "target": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a"
          },
          "vertices": [
            {
              "x": -1032,
              "y": -352
            },
            {
              "x": -968,
              "y": -304
            }
          ]
        },
        {
          "source": {
            "block": "4c4f5bfb-98c8-4c91-b3b6-a476684968a1",
            "port": "outlabel"
          },
          "target": {
            "block": "ff4e303c-6f2d-4da0-ba0e-c825b856f39b",
            "port": "0d45c6d8-c637-4f79-93e4-83384237bb8d"
          }
        }
      ]
    }
  },
  "dependencies": {
    "e9f5290f42a14ebe55607c33a03efea33bba5ff8": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "b5cc20d2-70d5-43ff-a0ce-e9e2bb207537",
              "type": "basic.input",
              "data": {
                "name": "RST",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": 136,
                "y": -40
              }
            },
            {
              "id": "e622ee99-88f5-4378-9f56-0201173bf4a1",
              "type": "basic.output",
              "data": {
                "name": "HV_EN"
              },
              "position": {
                "x": 1184,
                "y": -32
              }
            },
            {
              "id": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
              "type": "basic.input",
              "data": {
                "name": "DCLK",
                "clock": false
              },
              "position": {
                "x": 136,
                "y": 24
              }
            },
            {
              "id": "fb576a67-8424-4fc0-93fe-0c4932fb7b6a",
              "type": "basic.output",
              "data": {
                "name": "ADC_CLK"
              },
              "position": {
                "x": 1176,
                "y": 56
              }
            },
            {
              "id": "10715efa-451a-4739-9875-bb7a2593d7e6",
              "type": "basic.input",
              "data": {
                "name": "ADC_DATA",
                "range": "[9:0]",
                "clock": false,
                "size": 10
              },
              "position": {
                "x": 136,
                "y": 88
              }
            },
            {
              "id": "a471f67f-71bc-4738-8b6f-9a3f25e7d606",
              "type": "basic.output",
              "data": {
                "name": "RGB",
                "range": "[2:0]",
                "size": 3
              },
              "position": {
                "x": 1184,
                "y": 144
              }
            },
            {
              "id": "60c881ea-0572-4a65-85ae-b828f731a4e2",
              "type": "basic.input",
              "data": {
                "name": "TOP_T1",
                "clock": false
              },
              "position": {
                "x": 128,
                "y": 152
              }
            },
            {
              "id": "d8905bb3-e5d4-4758-883b-c0231d43be5f",
              "type": "basic.input",
              "data": {
                "name": "TOP_T2",
                "clock": false
              },
              "position": {
                "x": 120,
                "y": 216
              }
            },
            {
              "id": "70c88a81-6179-4b5d-8bb7-87e57b21bef9",
              "type": "basic.output",
              "data": {
                "name": "EA_CLK"
              },
              "position": {
                "x": 1192,
                "y": 224
              }
            },
            {
              "id": "1231be17-22e5-4c6c-b663-6cb0f1d40b49",
              "type": "basic.input",
              "data": {
                "name": "adc_trig",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": 120,
                "y": 280
              }
            },
            {
              "id": "be4a4edb-5cef-4720-bede-3b751b50c7fd",
              "type": "basic.output",
              "data": {
                "name": "adc_rd_data",
                "range": "[15:0]",
                "pins": [
                  {
                    "index": "15",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "14",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "13",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "12",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "11",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "10",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "9",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "8",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 1208,
                "y": 312
              }
            },
            {
              "id": "068747cf-63be-4e98-b340-e3535a3d1105",
              "type": "basic.input",
              "data": {
                "name": "adc_rd_addr",
                "range": "[12:0]",
                "pins": [
                  {
                    "index": "12",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "11",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "10",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "9",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "8",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": 128,
                "y": 344
              }
            },
            {
              "id": "7e7444d4-8e6e-404b-9f13-85c39c880027",
              "type": "basic.output",
              "data": {
                "name": "adc_wr_addr",
                "range": "[12:0]",
                "pins": [
                  {
                    "index": "12",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "11",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "10",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "9",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "8",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 1216,
                "y": 400
              }
            },
            {
              "id": "f0a21c67-b135-4eb5-b5f2-a911eab1190b",
              "type": "basic.input",
              "data": {
                "name": "HILO",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": 200,
                "y": 408
              }
            },
            {
              "id": "47479a02-c875-4b11-abaa-d960aaaccf08",
              "type": "basic.code",
              "data": {
                "code": " reg         adc_wr_en;\r\n wire [15:0] adc_wr_data;\r\n reg  [12:0] adc_wr_addr;\r\n \r\n defparam OSCInst0.CLKHF_DIV = \"0b00\";  //48MHz internal Clock\r\n SB_HFOSC OSCInst0 ( .CLKHFEN(1'b1), .CLKHFPU(1'b1),.CLKHF(ADC_CLK) \r\n ) /* synthesis ROUTE_THROUGH_FABRIC= [0] */;\r\n \r\n //@64MHz 8192 Clocks = 128us //@48MHz 8192 Clocks = 170.667us\r\n always@(posedge DCLK)begin \r\n  if(RST) begin //PWM_CLK pin\r\n   adc_wr_addr <= 13'h1fff;\r\n   adc_wr_en   <= 0;\r\n  end else if(adc_trig) begin\r\n   adc_wr_addr <= 0;\r\n   adc_wr_en   <= 1;\r\n  end else if(adc_wr_addr!=13'h1fff) begin\r\n   adc_wr_addr <= adc_wr_addr + 1;\r\n  end else if(adc_wr_addr==13'h1fff) begin\r\n   adc_wr_en   <= 0;\r\n  end\r\n end\r\n \r\n //SRAM for ADC DATA Writing and Reading\r\n assign adc_wr_data = {TOP_T2,TOP_T1,HV_EN,HILO,ADC_DATA,2'd0};\r\n wire [13:0] ADDRESS;\r\n assign ADDRESS = {1'b0,(adc_wr_en)?adc_wr_addr:adc_rd_addr};\r\n SB_SPRAM256KA ram(\r\n\t\t.DATAOUT(adc_rd_data),\r\n\t\t.ADDRESS(ADDRESS),\r\n\t\t.DATAIN(adc_wr_data),\r\n\t\t.MASKWREN(4'b1111),\r\n\t\t.WREN(adc_wr_en),\r\n\t\t.CHIPSELECT(1'b1),\r\n\t\t.CLOCK(DCLK),\r\n\t\t.STANDBY(1'b0),\r\n\t\t.SLEEP(1'b0),\r\n\t\t.POWEROFF(1'b1)\r\n );\r\n \r\n //Driving output LED for status monitering\r\n //Red  -> Capturing Data or Busy for SPI_Read\r\n //Green-> READY for Capture or Read\r\n //Blue -> Blinks during DAC Configuration\r\n SB_RGBA_DRV #(\r\n            .CURRENT_MODE (\"0b0\"),\r\n            .RGB0_CURRENT (\"0b111111\"),\r\n            .RGB1_CURRENT (\"0b111111\"),\r\n            .RGB2_CURRENT (\"0b111111\")\r\n ) RGB_driver (\r\n            .CURREN   (1'b1),       // I\r\n            .RGBLEDEN (1'b1),       // I\r\n            .RGB0PWM  (~adc_wr_en), // I\r\n            .RGB1PWM  (adc_wr_en),  // I\r\n            .RGB2PWM  (1'b1),  // I\r\n            .RGB2     (RGB[2]),      // O\r\n            .RGB1     (RGB[1]),     // O\r\n            .RGB0     (RGB[0])        // O\r\n );\r\n assign EA_CLK = adc_wr_en; \r\n assign HV_EN  = adc_wr_en;\r\n",
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
                      "name": "adc_trig"
                    },
                    {
                      "name": "adc_rd_addr",
                      "range": "[12:0]",
                      "size": 13
                    },
                    {
                      "name": "HILO"
                    }
                  ],
                  "out": [
                    {
                      "name": "HV_EN"
                    },
                    {
                      "name": "ADC_CLK"
                    },
                    {
                      "name": "RGB",
                      "range": "[2:0]",
                      "size": 3
                    },
                    {
                      "name": "EA_CLK"
                    },
                    {
                      "name": "adc_rd_data",
                      "range": "[15:0]",
                      "size": 16
                    },
                    {
                      "name": "adc_wr_addr",
                      "range": "[12:0]",
                      "size": 13
                    }
                  ]
                }
              },
              "position": {
                "x": 344,
                "y": -40
              },
              "size": {
                "width": 720,
                "height": 512
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "DCLK"
              },
              "vertices": []
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
              "vertices": [],
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
              "vertices": []
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
                "port": "HV_EN"
              },
              "target": {
                "block": "e622ee99-88f5-4378-9f56-0201173bf4a1",
                "port": "in"
              },
              "vertices": []
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
              "vertices": []
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
            },
            {
              "source": {
                "block": "f0a21c67-b135-4eb5-b5f2-a911eab1190b",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "HILO"
              }
            },
            {
              "source": {
                "block": "b5cc20d2-70d5-43ff-a0ce-e9e2bb207537",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "RST"
              }
            },
            {
              "source": {
                "block": "1231be17-22e5-4c6c-b663-6cb0f1d40b49",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_trig"
              }
            },
            {
              "source": {
                "block": "068747cf-63be-4e98-b340-e3535a3d1105",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_rd_addr"
              },
              "size": 13
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_rd_data"
              },
              "target": {
                "block": "be4a4edb-5cef-4720-bede-3b751b50c7fd",
                "port": "in"
              },
              "size": 16
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_wr_addr"
              },
              "target": {
                "block": "7e7444d4-8e6e-404b-9f13-85c39c880027",
                "port": "in"
              },
              "size": 13
            }
          ]
        }
      }
    },
    "447f87312c479a7a8dd41c27446b6230f2da8465": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a",
              "type": "basic.input",
              "data": {
                "name": "RST",
                "clock": false
              },
              "position": {
                "x": 392,
                "y": -16
              }
            },
            {
              "id": "e0b26a52-d8e0-4c6f-92fe-61e2590bf422",
              "type": "basic.output",
              "data": {
                "name": "F_MISO"
              },
              "position": {
                "x": 1328,
                "y": 24
              }
            },
            {
              "id": "854cf72c-eca3-434c-80a9-1db95058c488",
              "type": "basic.input",
              "data": {
                "name": "ICE_CS",
                "clock": false
              },
              "position": {
                "x": 384,
                "y": 88
              }
            },
            {
              "id": "5f1b7c11-baea-4b6c-aed8-29b3d86fa3dc",
              "type": "basic.input",
              "data": {
                "name": "F_SCLK",
                "clock": false
              },
              "position": {
                "x": 384,
                "y": 192
              }
            },
            {
              "id": "9a61d6c1-881c-4604-82b0-1b18716de30e",
              "type": "basic.output",
              "data": {
                "name": "from_spi",
                "range": "[7:0]",
                "pins": [
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 1336,
                "y": 192
              }
            },
            {
              "id": "9bccd4fc-8396-42d4-ac36-2d78a07d7457",
              "type": "basic.input",
              "data": {
                "name": "F_MOSI",
                "clock": false
              },
              "position": {
                "x": 384,
                "y": 288
              }
            },
            {
              "id": "4ee174eb-5f39-43e0-b4cd-a2250fb6eef0",
              "type": "basic.output",
              "data": {
                "name": "spi_strb",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 1336,
                "y": 360
              }
            },
            {
              "id": "f08dc332-ba74-4b0e-9efb-cdb1619b3a05",
              "type": "basic.input",
              "data": {
                "name": "to_spi",
                "range": "[7:0]",
                "pins": [
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": 384,
                "y": 392
              }
            },
            {
              "id": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
              "type": "basic.code",
              "data": {
                "code": "//SPI MODE 3: write(F_MISO)@negedge,read(F_MOSI)@posedge\r\nreg spi_strb;\r\nreg [7:0] from_spi,treg,rreg;\r\nreg [3:0] nb;\r\nassign F_MISO = (!ICE_CS) ? treg[7] : 1'bz; //1:send data,0: TRI-STATE\r\nalways @(posedge F_SCLK or posedge RST) begin\r\n    if (RST) begin\r\n\t\trreg\t = 8'h00;\r\n\t\tfrom_spi = 8'h00;\r\n\t\tspi_strb = 0;\r\n\t\tnb\t\t = 0;\r\n\tend else if (!ICE_CS) begin\r\n\t\trreg     = {rreg[6:0],F_MOSI}; //read from  F_MISO\r\n\t\tnb       = nb+1;\r\n\t\tif(nb!=8)\r\n            spi_strb = 0;\r\n\t\telse begin\r\n            from_spi = rreg;\r\n            spi_strb = 1;\r\n            nb       = 0;\r\n\t\tend\r\n\tend //!ICE_CS\r\nend\r\nalways @(negedge F_SCLK or posedge RST) begin\r\n    if (RST) begin\r\n\t\ttreg     = 8'hFF;\r\n\tend else if (!ICE_CS) begin\r\n\t\ttreg     = (nb==0) ? to_spi : {treg[6:0],1'b1}; //send to  F_MISO\r\n    end //!ICE_CS\r\nend\r\n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "RST"
                    },
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
                "x": 552,
                "y": -32
              },
              "size": {
                "width": 688,
                "height": 504
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
                "block": "f08dc332-ba74-4b0e-9efb-cdb1619b3a05",
                "port": "out"
              },
              "target": {
                "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
                "port": "to_spi"
              },
              "size": 8
            },
            {
              "source": {
                "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
                "port": "from_spi"
              },
              "target": {
                "block": "9a61d6c1-881c-4604-82b0-1b18716de30e",
                "port": "in"
              },
              "size": 8
            },
            {
              "source": {
                "block": "2bfdbaf2-6b44-4a2d-9364-6511b7437b17",
                "port": "spi_strb"
              },
              "target": {
                "block": "4ee174eb-5f39-43e0-b4cd-a2250fb6eef0",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "9af2a46e9d6a2785394cf99b1c1a1ef16e4fe0b9": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "40aba9de-15d7-476d-aca0-a628b90fcf13",
              "type": "basic.input",
              "data": {
                "name": "DCLK",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": -144,
                "y": 32
              }
            },
            {
              "id": "05780fc6-f779-4604-b2b3-c9ae3664ffe3",
              "type": "basic.output",
              "data": {
                "name": "DAC_CS",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 848,
                "y": 56
              }
            },
            {
              "id": "2591ea2f-06b8-4242-ab5a-feb0ff0bb894",
              "type": "basic.input",
              "data": {
                "name": "rst",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": -152,
                "y": 160
              }
            },
            {
              "id": "e5a9ed3b-8da6-42ac-b17d-c9c9771909a6",
              "type": "basic.output",
              "data": {
                "name": "DAC_SCLK",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 856,
                "y": 224
              }
            },
            {
              "id": "73f03e36-f316-48bd-8aba-a40c057fb00f",
              "type": "basic.input",
              "data": {
                "name": "dac_data",
                "range": "[15:0]",
                "pins": [
                  {
                    "index": "15",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "14",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "13",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "12",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "11",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "10",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "9",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "8",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "7",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "6",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "5",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "4",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "3",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "2",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "1",
                    "name": "",
                    "value": ""
                  },
                  {
                    "index": "0",
                    "name": "",
                    "value": ""
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": -152,
                "y": 288
              }
            },
            {
              "id": "89b9b13f-de9e-4ee7-8900-b16186970d8a",
              "type": "basic.output",
              "data": {
                "name": "DAC_MOSI",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false
              },
              "position": {
                "x": 856,
                "y": 392
              }
            },
            {
              "id": "b43084c9-33c8-4a3a-8d93-b6d46985a664",
              "type": "basic.input",
              "data": {
                "name": "dac_valid",
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ],
                "virtual": false,
                "clock": false
              },
              "position": {
                "x": -144,
                "y": 416
              }
            },
            {
              "id": "f8ab0d88-082e-407b-a6b5-b03178716d66",
              "type": "basic.code",
              "data": {
                "code": "localparam max_div_cnt = 10;\r\nreg data_valid_z, work, sck_int;\r\nreg [3:0] state;   reg [7:0]  clk_div_cnt;\r\nreg [4:0] bit_cnt; reg [15:0] shift_reg;\r\nassign DAC_SCLK       = sck_int && !DAC_CS;\r\nassign DAC_CS         = (bit_cnt < 16) ? ~work : 1;\r\nassign DAC_MOSI       = shift_reg[15];\r\nalways @(posedge DCLK or posedge rst) begin\r\n\tif (rst == 1) begin\r\n\t\twork<=0; data_valid_z<=0; clk_div_cnt<=0; bit_cnt<=0; sck_int<=0;\r\n\tend else begin\r\n\t\tdata_valid_z <= dac_valid;\r\n\t\tif (work == 0)\r\n\t\t\tsck_int <= 0;\r\n\t\telse if (clk_div_cnt == max_div_cnt) //clk_div_cnt_ov\r\n\t\t\tsck_int <= ~sck_int;\r\n\t\tif ((bit_cnt == 19) && (clk_div_cnt == max_div_cnt)) //end_work\r\n\t\t\twork <= 0;\r\n\t\telse if (dac_valid == 1 && data_valid_z == 0)\r\n\t\t\twork <= 1;\r\n\t\tif (dac_valid == 1 && data_valid_z == 0) begin\r\n\t\t\tshift_reg <= dac_data;\r\n\t\t\tbit_cnt <= 0;\r\n\t\tend else if ((clk_div_cnt == max_div_cnt) && sck_int == 1) begin\r\n\t\t\tshift_reg <= {shift_reg[14:0], 1'b0};\r\n\t\t\tbit_cnt <= bit_cnt + 1;\r\n\t\tend\r\n\t\tif((clk_div_cnt == max_div_cnt) || work == 0) clk_div_cnt <=  0;\r\n\t\telse clk_div_cnt <= clk_div_cnt + 1;\r\n\tend\r\nend\r\n",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "DCLK"
                    },
                    {
                      "name": "rst"
                    },
                    {
                      "name": "dac_data",
                      "range": "[15:0]",
                      "size": 16
                    },
                    {
                      "name": "dac_valid"
                    }
                  ],
                  "out": [
                    {
                      "name": "DAC_CS"
                    },
                    {
                      "name": "DAC_SCLK"
                    },
                    {
                      "name": "DAC_MOSI"
                    }
                  ]
                }
              },
              "position": {
                "x": 40,
                "y": 0
              },
              "size": {
                "width": 712,
                "height": 512
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "40aba9de-15d7-476d-aca0-a628b90fcf13",
                "port": "out"
              },
              "target": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "DCLK"
              }
            },
            {
              "source": {
                "block": "2591ea2f-06b8-4242-ab5a-feb0ff0bb894",
                "port": "out"
              },
              "target": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "rst"
              }
            },
            {
              "source": {
                "block": "73f03e36-f316-48bd-8aba-a40c057fb00f",
                "port": "out"
              },
              "target": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "dac_data"
              },
              "size": 16
            },
            {
              "source": {
                "block": "b43084c9-33c8-4a3a-8d93-b6d46985a664",
                "port": "out"
              },
              "target": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "dac_valid"
              }
            },
            {
              "source": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "DAC_CS"
              },
              "target": {
                "block": "05780fc6-f779-4604-b2b3-c9ae3664ffe3",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "DAC_SCLK"
              },
              "target": {
                "block": "e5a9ed3b-8da6-42ac-b17d-c9c9771909a6",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "f8ab0d88-082e-407b-a6b5-b03178716d66",
                "port": "DAC_MOSI"
              },
              "target": {
                "block": "89b9b13f-de9e-4ee7-8900-b16186970d8a",
                "port": "in"
              }
            }
          ]
        }
      }
    },
    "014e8276d880bc58cf670b2e4e6dd4f6742a6667": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "7503dafb-35ab-42f2-9c16-90b6d019244f",
              "type": "basic.output",
              "data": {
                "name": "PHV"
              },
              "position": {
                "x": 1432,
                "y": 176
              }
            },
            {
              "id": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
              "type": "basic.input",
              "data": {
                "name": "DCLK",
                "clock": false
              },
              "position": {
                "x": 536,
                "y": 200
              }
            },
            {
              "id": "1fe4900d-fd18-4d05-b8b2-3ac13aa088f4",
              "type": "basic.output",
              "data": {
                "name": "PnHV"
              },
              "position": {
                "x": 1432,
                "y": 256
              }
            },
            {
              "id": "4264b6f3-d5a8-45b1-bd3b-ad8103fe054d",
              "type": "basic.input",
              "data": {
                "name": "adc_wr_addr",
                "range": "[12:0]",
                "clock": false,
                "size": 13
              },
              "position": {
                "x": 480,
                "y": 320
              }
            },
            {
              "id": "1318e52a-b44b-4493-8a9d-5fe0f7c553f1",
              "type": "basic.output",
              "data": {
                "name": "Pdamp"
              },
              "position": {
                "x": 1432,
                "y": 336
              }
            },
            {
              "id": "47479a02-c875-4b11-abaa-d960aaaccf08",
              "type": "basic.code",
              "data": {
                "code": "reg PHV,PnHV,Pdamp;\r\n //Pulsar signals generation\r\n //@64MHz 8 clocks = 125ns; 32 clocks = 500ns; 64 clocks = 1000ns;\r\n //@48MHz 6 clocks = 125ns; 24 clocks = 500ns; 48 clocks = 1000ns;\r\n always@(posedge DCLK)begin\r\n//  PHV   <= (adc_wr_addr>=32 && adc_wr_addr<40 ) ? 1'b1 : 1'b0;\r\n//  PnHV  <= (adc_wr_addr>=48 && adc_wr_addr<56 ) ? 1'b1 : 1'b0;\r\n//  Pdamp <= (adc_wr_addr>=64 && adc_wr_addr<128) ? 1'b1 : 1'b0;\r\n  PHV   <= (adc_wr_addr>=24 && adc_wr_addr<30 ) ? 1'b1 : 1'b0;\r\n  PnHV  <= (adc_wr_addr>=36 && adc_wr_addr<42 ) ? 1'b1 : 1'b0;\r\n  Pdamp <= (adc_wr_addr>=48 && adc_wr_addr<96 ) ? 1'b1 : 1'b0;\r\n end\r\n ",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "DCLK"
                    },
                    {
                      "name": "adc_wr_addr",
                      "range": "[12:0]",
                      "size": 13
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
                    }
                  ]
                }
              },
              "position": {
                "x": 696,
                "y": 168
              },
              "size": {
                "width": 640,
                "height": 240
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "DCLK"
              },
              "vertices": []
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
              "vertices": []
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
              "vertices": []
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
              "vertices": []
            },
            {
              "source": {
                "block": "4264b6f3-d5a8-45b1-bd3b-ad8103fe054d",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_wr_addr"
              },
              "size": 13
            }
          ]
        }
      }
    },
    "fa63e7d4e7a5fa2bb234c1e95c5be6e897392d39": {
      "package": {
        "name": "",
        "version": "",
        "description": "",
        "author": "",
        "image": ""
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "a9f2add9-6d4e-43c6-bfb5-2a13f4ddf179",
              "type": "basic.output",
              "data": {
                "name": "dac_data",
                "range": "[15:0]",
                "size": 16
              },
              "position": {
                "x": 1256,
                "y": -24
              }
            },
            {
              "id": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
              "type": "basic.input",
              "data": {
                "name": "DCLK",
                "clock": false
              },
              "position": {
                "x": 72,
                "y": -16
              }
            },
            {
              "id": "a06bd8b6-abf9-4c86-bf78-b423d8d6d1c7",
              "type": "basic.output",
              "data": {
                "name": "dac_valid"
              },
              "position": {
                "x": 1256,
                "y": 112
              }
            },
            {
              "id": "e368f73b-aa74-4bc5-a9b8-229e78b54c5a",
              "type": "basic.input",
              "data": {
                "name": "RST",
                "clock": false
              },
              "position": {
                "x": 80,
                "y": 152
              }
            },
            {
              "id": "53212cc3-896c-4536-a049-678713014b85",
              "type": "basic.output",
              "data": {
                "name": "adc_trig"
              },
              "position": {
                "x": 1256,
                "y": 248
              }
            },
            {
              "id": "44233d4d-a707-4c10-9d0f-afa604106b4f",
              "type": "basic.input",
              "data": {
                "name": "from_spi",
                "range": "[7:0]",
                "clock": false,
                "size": 8
              },
              "position": {
                "x": 88,
                "y": 320
              }
            },
            {
              "id": "88bb51e0-e6fd-4b61-93c7-f0dffd168b5f",
              "type": "basic.output",
              "data": {
                "name": "adc_rd_addr",
                "range": "[12:0]",
                "size": 13,
                "virtual": false
              },
              "position": {
                "x": 1264,
                "y": 384
              }
            },
            {
              "id": "a49f5dec-518f-41f1-b55d-54313d15b85a",
              "type": "basic.input",
              "data": {
                "name": "spi_strb",
                "clock": false
              },
              "position": {
                "x": 88,
                "y": 480
              }
            },
            {
              "id": "e99a9b94-0282-4de2-98bb-d8c82797a17e",
              "type": "basic.output",
              "data": {
                "name": "HILO"
              },
              "position": {
                "x": 1272,
                "y": 520
              }
            },
            {
              "id": "c7aef478-81c1-46e5-8540-4229b335b23c",
              "type": "basic.input",
              "data": {
                "name": "adc_rd_data",
                "range": "[15:0]",
                "clock": false,
                "size": 16
              },
              "position": {
                "x": 80,
                "y": 648
              }
            },
            {
              "id": "9abfeb3d-dc5f-45c7-b5c9-245706e6335f",
              "type": "basic.output",
              "data": {
                "name": "to_spi",
                "range": "[7:0]",
                "size": 8
              },
              "position": {
                "x": 1272,
                "y": 656
              }
            },
            {
              "id": "47479a02-c875-4b11-abaa-d960aaaccf08",
              "type": "basic.code",
              "data": {
                "code": " reg         adc_trig;\r\n reg  [15:0] dac_data;\r\n reg         dac_valid;\r\n reg         HILO;\r\n reg  [12:0] adc_rd_addr;\r\n reg  [15:0] spi_data;\r\n reg  [13:0] spi_data_active;\r\n reg         spi_strb_adc_clk;\r\n reg         spi_strb_adc_clk_z;\r\n reg         spi_strb_adc_clk_zz;\r\n reg         spi_strb_adc_clk_zzz;\r\n reg         spi_strb_adc_clk_zzzz;\r\n reg         spi_data_byte;\r\n reg  [1:0]  spi_mode;\r\n assign to_spi = (spi_data_byte == 0) ? adc_rd_data[7:0] : adc_rd_data[15:8];\r\n always @(posedge DCLK or posedge RST) begin //Clock domain crossing Logic\r\n\tif (RST) begin\r\n\t\tspi_data <= 0;\r\n\t\tspi_strb_adc_clk <= 0;\r\n\t\tspi_strb_adc_clk_z <= 0;\r\n\t\tspi_strb_adc_clk_zz <= 0;\r\n\t\tspi_strb_adc_clk_zzz <= 0;\r\n\t\tspi_strb_adc_clk_zzzz <= 0;\r\n\t\tspi_data_byte <= 0;\r\n\tend else begin\r\n\t\tspi_strb_adc_clk_zzzz <= spi_strb_adc_clk_zzz;\r\n\t\tspi_strb_adc_clk_zzz <= spi_strb_adc_clk_zz;\r\n\t\tspi_strb_adc_clk_zz <= spi_strb_adc_clk_z;\r\n\t\tspi_strb_adc_clk_z <= spi_strb_adc_clk;\r\n\t\tspi_strb_adc_clk <= spi_strb;\r\n\t\tif (spi_strb_adc_clk_zzzz == 0 && spi_strb_adc_clk_zzz == 1 && spi_data_byte == 0) begin\r\n\t\t\t{spi_mode,spi_data_active} <= spi_data;\r\n\t\tend else spi_mode <= 0;\r\n\t\tif (spi_strb_adc_clk_zzz == 0 && spi_strb_adc_clk_zz == 1) begin\r\n\t\t\tspi_data <= {spi_data[7:0], from_spi};\r\n\t\t\tspi_data_byte <= ~spi_data_byte;\r\n\t\tend\r\n\tend\r\n end\r\n always@(posedge DCLK)begin\r\n   if(RST)begin\r\n    adc_trig       <= 0;\r\n    HILO           <= 0;\r\n    dac_data       <= 0;\r\n    dac_valid      <= 0;\r\n\tadc_rd_addr    <= 0;\r\n   end else begin\r\n    adc_trig       <= (spi_mode==2'b01);\r\n    HILO           <= (spi_mode==2'b01) ? spi_data_active[0] : HILO;\r\n    dac_data[7:0]  <= (spi_mode==2'b10)?spi_data_active[7:0]:dac_data[7:0];\r\n    dac_data[15:8] <= (spi_mode==2'b11)?spi_data_active[7:0]:dac_data[15:8];\r\n    dac_valid      <= (spi_mode==2'b11);\r\n\tadc_rd_addr    <= spi_data_active[12:0];\r\n   end\r\n end\r\n ",
                "params": [],
                "ports": {
                  "in": [
                    {
                      "name": "DCLK"
                    },
                    {
                      "name": "RST"
                    },
                    {
                      "name": "from_spi",
                      "range": "[7:0]",
                      "size": 8
                    },
                    {
                      "name": "spi_strb"
                    },
                    {
                      "name": "adc_rd_data",
                      "range": "[15:0]",
                      "size": 16
                    }
                  ],
                  "out": [
                    {
                      "name": "dac_data",
                      "range": "[15:0]",
                      "size": 16
                    },
                    {
                      "name": "dac_valid"
                    },
                    {
                      "name": "adc_trig"
                    },
                    {
                      "name": "adc_rd_addr",
                      "range": "[12:0]",
                      "size": 13
                    },
                    {
                      "name": "HILO"
                    },
                    {
                      "name": "to_spi",
                      "range": "[7:0]",
                      "size": 8
                    }
                  ]
                }
              },
              "position": {
                "x": 280,
                "y": -64
              },
              "size": {
                "width": 864,
                "height": 824
              }
            }
          ],
          "wires": [
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
                "block": "0d45c6d8-c637-4f79-93e4-83384237bb8d",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "DCLK"
              },
              "vertices": []
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
              "vertices": []
            },
            {
              "source": {
                "block": "44233d4d-a707-4c10-9d0f-afa604106b4f",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "from_spi"
              },
              "size": 8
            },
            {
              "source": {
                "block": "a49f5dec-518f-41f1-b55d-54313d15b85a",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "spi_strb"
              }
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "to_spi"
              },
              "target": {
                "block": "9abfeb3d-dc5f-45c7-b5c9-245706e6335f",
                "port": "in"
              },
              "size": 8
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_trig"
              },
              "target": {
                "block": "53212cc3-896c-4536-a049-678713014b85",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "dac_data"
              },
              "target": {
                "block": "a9f2add9-6d4e-43c6-bfb5-2a13f4ddf179",
                "port": "in"
              },
              "size": 16
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "dac_valid"
              },
              "target": {
                "block": "a06bd8b6-abf9-4c86-bf78-b423d8d6d1c7",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_rd_addr"
              },
              "target": {
                "block": "88bb51e0-e6fd-4b61-93c7-f0dffd168b5f",
                "port": "in"
              },
              "size": 13
            },
            {
              "source": {
                "block": "c7aef478-81c1-46e5-8540-4229b335b23c",
                "port": "out"
              },
              "target": {
                "block": "47479a02-c875-4b11-abaa-d960aaaccf08",
                "port": "adc_rd_data"
              },
              "size": 16
            }
          ]
        }
      }
    }
  }
}
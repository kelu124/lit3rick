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
          "id": "a2477b9e-e777-46c5-b5d0-bdede4116163",
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
            "x": 544,
            "y": 8
          }
        },
        {
          "id": "0e3066af-b2c1-4367-b34f-f0cf35ff8320",
          "type": "basic.code",
          "data": {
            "code": "wire clk48,clk64; // High frequency oscillator\ndefparam OSCInst0.CLKHF_DIV = \"0b00\";\nSB_HFOSC OSCInst0(.CLKHFEN(1'b1), \n.CLKHFPU(1'b1),.CLKHF(clk48)  //48MHz\n) /* synthesis ROUTE_THROUGH_FABRIC= [0] */;\nSB_PLL40_CORE pll(.REFERENCECLK(clk48),\n.PLLOUTCORE(clk64),.PLLOUTGLOBAL(),//64MHz\n.RESETB(1'b1),.BYPASS(1'b0),.LOCK(blink));\n//\\\\ Fin=48, Fout=64;\ndefparam pll.DIVR = 4'b0010;\ndefparam pll.DIVF = 7'b0111111;\ndefparam pll.DIVQ = 3'b100;\ndefparam pll.FILTER_RANGE = 3'b001;\ndefparam pll.FEEDBACK_PATH = \"SIMPLE\";\ndefparam pll.DELAY_ADJUSTMENT_MODE_FEEDBACK = \"FIXED\";\ndefparam pll.FDA_FEEDBACK = 4'b0000;\ndefparam pll.DELAY_ADJUSTMENT_MODE_RELATIVE = \"FIXED\";\ndefparam pll.FDA_RELATIVE = 4'b0000;\ndefparam pll.SHIFTREG_DIV_MODE = 2'b00;\ndefparam pll.PLLOUT_SELECT = \"GENCLK\";\ndefparam pll.ENABLE_ICEGATE = 1'b0;\nreg [31:0] cnt;\nalways@(posedge clk64)begin\n cnt=(cnt==(64000000-1))?0:cnt+1;\n //blink = ~blink;\nend\n",
            "params": [],
            "ports": {
              "in": [],
              "out": [
                {
                  "name": "blink"
                }
              ]
            }
          },
          "position": {
            "x": -24,
            "y": -208
          },
          "size": {
            "width": 528,
            "height": 488
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "0e3066af-b2c1-4367-b34f-f0cf35ff8320",
            "port": "blink"
          },
          "target": {
            "block": "a2477b9e-e777-46c5-b5d0-bdede4116163",
            "port": "in"
          }
        }
      ]
    }
  },
  "dependencies": {}
}
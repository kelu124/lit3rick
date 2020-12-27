gpio mode 4 IN
cdone_stat=$(gpio read 4)

gpio mode 24 IN
fpga_stat=$(gpio read 24)

gpio mode 28 IN
cpu_stat=$(gpio read 28)

echo "cdone status: $cdone_stat"
echo "fpga status: $fpga_stat"
echo "cpu status: $cpu_stat"

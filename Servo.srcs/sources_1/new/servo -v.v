`timescale 1ns / 1ps
module servo(
input clk,         //ʱ�� 50MHz
input sw1,          //���ٰ���
output reg pwm     //pwm���
);

reg [19:0] pwm_val;       //ռ�ձȼ���ֵ
reg [3:0] speed = 4'd2;   //ת��Ƕ�ѡ��
parameter max_cnt=1000_000; 
reg [19:0] clk_cnt;

always @(posedge clk)begin //����20ms���ڼ�ʱ
    if(clk_cnt==max_cnt)begin
    clk_cnt=20'b0;
    end
    else begin
    clk_cnt=clk_cnt+1'b1;
    end
end

//PWM����ģ��
always @ (posedge clk) begin
    if(clk_cnt < pwm_val) begin           //�����pwm_val�ڣ�����ߵ�ƽ
    pwm <=1'b1;
    end
    else begin                   //�������pwm_val��������͵�ƽ
    pwm <=1'b0;                  //����͵�ƽ
    end
    case(speed)
        1: pwm_val <= 20'd50_000; //ռ�ձ�Ϊ5% 1ms
        2: pwm_val <= 20'd100_000; //10% 2ms
        3: pwm_val <= 20'd25_000;
        4: pwm_val <= 20'd75_000;
        5: pwm_val <= 20'd1_000;
        default: pwm_val <= 20'd1_000;
    endcase
end

//���ص���
always @ (posedge clk) begin
    if(sw1) begin
        speed <= 4'd1;
    end             
    else begin
        speed <= 4'd2;
    end
end
   
endmodule
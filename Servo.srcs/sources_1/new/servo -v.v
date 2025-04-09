`timescale 1ns / 1ps
module servo(
input clk,         //时钟 50MHz
input sw1,          //调速按键
output reg pwm     //pwm输出
);

reg [19:0] pwm_val;       //占空比计数值
reg [3:0] speed = 4'd2;   //转向角度选择
parameter max_cnt=1000_000; 
reg [19:0] clk_cnt;

always @(posedge clk)begin //产生20ms周期计时
    if(clk_cnt==max_cnt)begin
    clk_cnt=20'b0;
    end
    else begin
    clk_cnt=clk_cnt+1'b1;
    end
end

//PWM产生模块
always @ (posedge clk) begin
    if(clk_cnt < pwm_val) begin           //如果在pwm_val内，输出高电平
    pwm <=1'b1;
    end
    else begin                   //如果超出pwm_val，则输出低电平
    pwm <=1'b0;                  //输出低电平
    end
    case(speed)
        1: pwm_val <= 20'd50_000; //占空比为5% 1ms
        2: pwm_val <= 20'd100_000; //10% 2ms
        3: pwm_val <= 20'd25_000;
        4: pwm_val <= 20'd75_000;
        5: pwm_val <= 20'd1_000;
        default: pwm_val <= 20'd1_000;
    endcase
end

//开关调速
always @ (posedge clk) begin
    if(sw1) begin
        speed <= 4'd1;
    end             
    else begin
        speed <= 4'd2;
    end
end
   
endmodule
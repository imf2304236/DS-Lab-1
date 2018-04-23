# compile project AUDIO_SYSTEM_TOP
#vlib work
#vcom -93 -work work AUDIO_SYSTEM_TOP.vhd

# simulate AUDIO_SYSTEM_TOP
vsim AUDIO_SYSTEM_TOP
view wave
radix hex 

# display clocks
#add wave -divider -height 32 Clocks
add wave -height 32 -radix default SRESETN
add wave -height 32 -radix default CLK
add wave -height 32 -radix default SYSCLK
add wave -height 32 -radix default BCK
add wave -height 32 -radix default LRC

# display contents of shift regs
add wave -divider -height 32 Shift_Regs
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/INST_SER_TO_PAR_LR/SHIFT_REG_L
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/INST_SER_TO_PAR_LR/SHIFT_REG_R
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/INST_PAR_TO_SER_LR/SHIFT_REG_L
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/INST_PAR_TO_SER_LR/SHIFT_REG_R


# display PAR_TO_SER input signals
add wave -divider -height 32 PAR_TO_SER_Inputs
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/PAR_IN_L
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/PAR_IN_R
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/SHIFT_OUT_L
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/SHIFT_OUT_R
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/SAVE_R_LOAD_L
add wave -height 32 -radix default INST_AUDIO_CODEC_COM/SAVE_L_LOAD_R

# display ADC path
add wave -divider -height 32 ADC_PATH
add wave -height 32 -radix default DIN

# display DAC path
add wave -divider -height 32 DAC_PATH
add wave -height 32 -radix default DOUT

# generate input stimuli + start sim 
force CLK      0 0ns, 1 5ns   -r 10ns
force SRESETN  0 0ns, 1 25ns
force DIN 0 0ns, 0 1285ns,1 2565ns,0 3845ns,1 5125ns,1 6405ns,1 8965ns,1 10245ns,1 11525ns,0 12805ns,0 14085ns,0 15365ns,0 16645ns,1 17925ns,0 19205ns,1 20485ns,0 21765ns,1 23045ns,1 24325ns,1 25605ns,0 26885ns,1 28165ns,0 29445ns,1 30725ns,0 32005ns,0 33285ns,1 34565ns,1 35845ns,0 37125ns,0 38405ns,1 39685ns,1 40965ns
-- force DIN 0 0ns, 1 1285ns,0 2565ns,1 3845ns,0 5125ns,1 6405ns,0 8965ns,1 10245ns,0 11525ns,1 12805ns,0 14085ns,1 15365ns,0 16645ns,1 17925ns,0 19205ns,1 20485ns,0 21765ns,1 23045ns,0 24325ns,1 25605ns,0 26885ns,1 28165ns,0 29445ns,1 30725ns,0 32005ns,1 33285ns,0 34565ns,1 35845ns,0 37125ns,1 38405ns,0 39685ns,1 40965ns -r 42245ns
-- force DIN 	0 0ns,0 1285ns, 0 2565ns, 0 3845ns, 0 5125ns, 0 6405ns, 0 8965ns, 0 10245ns,0 11525ns,0 12805ns,0 14085ns,0 15365ns,0 16645ns,0 17925ns,0 19205ns,0 20485ns,1 21765ns,1 23045ns,1 24325ns,1 25605ns,1 26885ns,1 28165ns,1 29445ns,1 30725ns,1 32005ns,1 33285ns,1 34565ns,1 35845ns,1 37125ns,1 38405ns,1 39685ns,1 40965ns -r 42245ns
run 500us

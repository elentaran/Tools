#!/usr/bin/ruby

##### those variable need to be configured for the script to work
#####
#
# command to execute. put "PARAM" where the parameter is used.
#$execProg = 'make opt CPPFLAG="PARAM"; ./latinSquare'     
$execProg = 'mkdir "tempPARAM"; cp *.cpp *.h Makefile computeStats.rb "tempPARAM"; cd "tempPARAM"; make opt CPPFLAG="PARAM"; ./computeStats.rb 1000; cd ..; rm -r "tempPARAM"'     
#$execProg = './computeStats.rb 100 "./latinSquare -probaKeep PARAM"'
#$execProg = './computeStats.rb 10'     


# list of parameter values. a..b for all the values between a and b or [a,b,c] for the values a, b and c.
#$paramValues = ["-DDIM=4 -DLARGEUR=25","-DDIM=9 -DLARGEUR=10","-DDIM=8 -DLARGEUR=20" ,"-DDIM=3 -DLARGEUR=20","-DDIM=2 -DLARGEUR=20"]       
#$paramValues = ["-DDIM=4 -DLARGEUR=25","-DDIM=9 -DLARGEUR=10","-DDIM=8 -DLARGEUR=20"]
#param1 = ["-DDIM="].product((3..10).to_a).map(&:join)
#param2 = [" -DLARGEUR="].product((2..25).to_a).map(&:join)
#$paramValues = param1.product(param2).map(&:join)
#$paramValues = (0..10).to_a
#$paramValues = [0,3,5]
#$paramValues = ["-DDIM=4 -DLARGEUR=25","-DDIM=9 -DLARGEUR=10","-DDIM=8 -DLARGEUR=20"]
#param1 = ["-DVALUE_P="].product(["1","5","10","20"]).map(&:join)
#param2 = [" -DDIM=4 -DLARGEUR=25"," -DDIM=9 -DLARGEUR=10"," -DDIM=8 -DLARGEUR=20"]
#$paramValues = param1.product(param2).map(&:join)
param1 = ["-DMUTATION="].product(["1","2","4","5"]).map(&:join)
param2 = [" -DDIM=4 -DLARGEUR=25"," -DDIM=9 -DLARGEUR=10"," -DDIM=8 -DLARGEUR=20"]
$paramValues = param1.product(param2).map(&:join)

# name of the file where the results will be stored (if empty, results will be printed on screen).
$fileRes = ""             

# number of cores that should be used
$nbcores = 1

#####



def execCmd(param)
    execCmd = $execProg
    if (execCmd.include?("PARAM"))
        execCmd = execCmd.gsub(/PARAM/, "#{param}")
    end
    #puts execCmd
    value = `#{execCmd}`
    if (!$?.success?)
        puts "error during the execution"
        exit
    else
        if ($fileRes.empty?)
            puts "param = " + param.to_s
            puts value
            puts ""
        else
            puts "param = " + param.to_s + " (" + $paramValues.length.to_s + " left)"
            f = File.open($fileRes,'a')
            f.puts "param = " + param.to_s
            f.puts value
            f.puts ""
            f.close
        end
    end
end

def func()
    while (!$paramValues.empty?) do
        param = $paramValues.first
        $paramValues = $paramValues.drop(1)
        execCmd(param)
    end
end

listThread = []
for i in 1..$nbcores do
    listThread[i] = Thread.new{func()}
end

for i in 1..$nbcores do
    listThread[i].join
end



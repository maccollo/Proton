close all
clc
clear all

rocket = struct('massInert',[],'massProp',[],'propDensity',[],'propFlow',[],'thrust',0,'ISP',0,'gasVolume',[],'gasPressure',[],'nozzleArea',[],'position',[],'velocity',[],'direction',[],'area',[],'cD',[],'cdVe',[])
rocket.massInert = 0.2 %flaskan väger 50 gram + 50 gram fenor och grejer
rocket.massProp = 0.5*1.5 %en halv liter drivmedel/vatten
rocket.propDensity = 1000 %vatten väger 1000 kg/m^3
rocket.propFlow = 0 %vatten väger 1000 kg/m^3
rocket.gasVolume = 0.0005*1.5 % 0.5 liter tryckgas
rocket.gasPressure = 8e+5 % 4 bar startTryck
rocket.nozzleArea = 0.02^2/4*pi %1.5 cm strupe
rocket.position = [0 0.1 0]
rocket.velocity = [0 0 0]
angle = 45
rocket.direction = cos(angle*pi/180)*[1 0 0]+sin(angle*pi/180)*[0 1 0]
rocket.area = 0.09^2/4*pi %korssektionen överskattas något
rocket.cD = 0.35  %cd är groovt uppskattat till 0.35
rocket.cdVe = 1*sqrt(2);

env = struct('pressure',[],'density',[],'gravity',[])
env.pressure = 1e5 % 1 bar lufttryck
env.density = 1.22 % 1.22 kg luft per m^3
env.gravity = 9.82*[0 -1 0] % gravitationsvektorn

settings = struct('maxT', [], 'timeStep', [],'doPlot',0)
settings.maxT = 20 %max 20 sekunders simulering
settings.timeStep = 0.001 %hundradels sekunders steglängd


p = simulateRocket(rocket, env, settings)
pmax = 0; 
volume = 1.5
 for m = 0.13:0.001:0.17
    for a = 43:0.5:47
        for r = 0.4:0.01:0.5
        rocket.massInert = m;
        rocket.massProp = r*volume;
        rocket.gasVolume = volume*(1-r)/1000;
        rocket.direction = cos(a*pi/180)*[1 0 0]+sin(a*pi/180)*[0 1 0];
        p = simulateRocket(rocket, env, settings);
            if p > pmax
                bestAngle = a;
                bestInert= rocket.massInert;
                bestProp = rocket.massProp;
                bestVol = rocket.gasVolume;
                pmax = p;
            end
        end
    end
 end
 
 pmax
 bestAngle
 bestInert
 bestProp
 bestVol
 bestProp/volume
 bestVol/volume
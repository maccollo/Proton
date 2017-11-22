function distance = simulateRocket(rocket,env, settings)
Ve = @(a,p,d,k)(sqrt((p)/d))*k;
flowRateV = @(a,p,d,k)a*Ve(a,p,d,k);
flowRateM = @(a,p,d,k)flowRateV(a,p,d,k)*d;

time = 0;
abiaticConstant = rocket.gasVolume^(7/5)*rocket.gasPressure;
i = 0;
deltaV = 0;
endSimulation = 0;
deltaVSum = 0;
burnout = 0;
while endSimulation == 0
    time = time+settings.timeStep;
    i = i+1;
    deltaV = 0;
    if burnout == 0
        rocket.propFlow = flowRateM(rocket.nozzleArea,rocket.gasPressure-env.pressure,rocket.propDensity,rocket.cdVe);
        if (rocket.massProp-rocket.propFlow*settings.timeStep > 0 && rocket.gasPressure-env.pressure > 0)



            rocket.ISP = Ve(rocket.nozzleArea,rocket.gasPressure-env.pressure,rocket.propDensity,rocket.cdVe);

            deltaV = rocket.ISP*log((rocket.massProp+rocket.massInert)/(rocket.massProp+rocket.massInert-rocket.propFlow*settings.timeStep));
            deltaVSum = deltaVSum + deltaV;

            rocket.massProp = rocket.massProp-rocket.propFlow*settings.timeStep;
            rocket.gasVolume = rocket.gasVolume+rocket.propFlow/rocket.propDensity*settings.timeStep;
            rocket.gasPressure = abiaticConstant/rocket.gasVolume^(7/5);


        else
            
            rocket.ISP = Ve(rocket.nozzleArea,rocket.gasPressure-env.pressure,rocket.propDensity,rocket.cdVe);
            deltaV = rocket.ISP*log((rocket.massProp+rocket.massInert)/(rocket.massInert));
            rocket.massProp = 0;
            burnout = 1;
            settings.timeStep = 0.01

        end
    end
    accelerationDrag = rocket.velocity*(norm(rocket.velocity)*env.density*rocket.area*rocket.cD/(rocket.massProp+rocket.massInert)/2);
    
    rocket.position = rocket.position + (settings.timeStep*rocket.velocity + settings.timeStep^2*env.gravity/2) + (settings.timeStep^2*rocket.direction*deltaV/2 - settings.timeStep^2*accelerationDrag/2);
    rocket.velocity = rocket.velocity + settings.timeStep*env.gravity + rocket.direction*deltaV - settings.timeStep*accelerationDrag;
    if norm(rocket.velocity) > 0.0000001
        rocket.direction = rocket.velocity/norm(rocket.velocity);
    end

%         pressureVec(i) = rocket.gasPressure;
%         flowRateVec(i) = rocket.propFlow;
%         VeVec(i) = rocket.ISP;
%         propVec(i)=rocket.massProp;
%         volumeVec(i) = rocket.gasVolume;
%         position(:,i) = rocket.position';
%         velocity(:,i) = rocket.velocity';
%         direciton(:,i) = rocket.direction';
        
if rocket.position(2) <= 0
    endSimulation = 1;
end
    
end

% rocket.massProp
% statTable = table(pressureVec',flowRateVec',VeVec',propVec',volumeVec');
% statTable.Properties.VariableNames = {'pressure' 'propFlow' 'Ve' 'propellant' 'gasVolume'};
distance = norm(rocket.position);
% plot(position(1,:),position(2,:));
deltaVSum;
end
classdef DAQparam < handle
    properties
        %references of physical objects
        PhotonCounter
        NIDAQ
        ADC
        Pump
        PHmeter
        Stage
             
        %parameters for photon counter
        ScanLength = Inf;
        Interval = 1;
        DwellTime = 0.002;
        Channel = 'A';
        
        %booleans of if enabled for an acquisition
        PhotonCounterEnabled = true;
        ADCpowerEnabled = false;
        FlowControl = false;
        PHmeterEnabled = false;
        StageControlEnabled = false;

        %parameters for flow control
        FlowConcentrationPoint;
        FlowConcentrationValue;
        
        %name
        Name
        
        %automatic pause for acquisitions
        AutoPause = 0;
    end
end
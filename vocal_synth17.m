% --- VocalSynth V17 (The Pro Synth Update) ---
% 1. ΟΡΙΣΜΟΣ ΠΑΡΑΜΕΤΡΩΝ
fs = 16000; 
frameSize = 1024; 
maxDuration = 60;
noteNames = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};

% 2. ΔΗΜΙΟΥΡΓΙΑ ΠΑΡΑΘΥΡΟΥ 
% Κλείνουμε το χαλασμένο AutoResize του MATLAB για να βάλουμε το δικό μας
fig = uifigure('Name', 'VocalSynth', 'Position', [400, 200, 750, 440], ...
    'Color', [0.12 0.12 0.16], 'AutoResizeChildren', 'off');

% Κεντρικός Τίτλος (Οι δικές σου αλλαγές)
uilabel(fig, 'Text', '🎙️ VocalSynth', 'FontSize', 28, 'FontWeight', 'bold', 'FontName', 'Segoe UI', ...
    'FontColor', [0.3 0.8 1], 'Position', [20, 380, 250, 60]);
uilabel(fig, 'Text', 'brought to you by PanosEmm', 'FontSize', 9, 'FontWeight', 'bold', 'FontName', 'Segoe UI', ...
    'FontColor', [0.47 0.63 0.73], 'Position', [30, 360, 200, 40]);

% --- "Bubble" 1: Πάνελ Ρυθμίσεων (GLASS GRADIENT) ---
settingsBgHtml = ['<html><body style="margin:0; overflow:hidden; background-color:rgb(31,31,41);">', ...
              '<div style="width:100%; height:100%; background:linear-gradient(145deg, #2e2e38, #181821); ', ...
              'border-radius:15px; box-sizing:border-box; border: 1px solid rgb(60,60,70); ', ...
              'box-shadow: 0px 4px 10px rgba(0,0,0,0.2);"></div>', ...
              '</body></html>'];
uihtml(fig, 'Position', [20, 160, 380, 200], 'HTMLSource', settingsBgHtml);

uilabel(fig, 'Text', 'ΡΥΘΜΙΣΕΙΣ ΗΧΟΥ', 'Position', [35, 330, 150, 22], ...
    'FontColor', [0.5 0.5 0.6], 'FontWeight', 'bold', 'FontName', 'Segoe UI', 'FontSize', 11);

% 1. Waveform Dropdown
uilabel(fig, 'Text', 'Χροιά (Wave):', 'Position', [35, 290, 120, 22], 'FontColor', [0.9 0.9 0.9], 'FontName', 'Segoe UI', 'FontSize', 13);
waveDrop = uidropdown(fig, 'Items', {'Γλυκό (Ημίτονα)', '8-bit (Τετραγωνικό)', 'Sci-Fi (Πριονωτό)', 'Βιολί (Violin)'}, ...
    'Position', [150, 287, 230, 28], 'BackgroundColor', [0.25 0.25 0.3], 'FontColor', [1 1 1], 'FontName', 'Segoe UI');

% 2. Octave Dropdown
uilabel(fig, 'Text', 'Οκτάβα (Pitch):', 'Position', [35, 250, 120, 22], 'FontColor', [0.9 0.9 0.9], 'FontName', 'Segoe UI', 'FontSize', 13);
octaveDrop = uidropdown(fig, 'Items', {'-1 (Μπάσο)', '0 (Κανονικό)', '+1 (Πρίμο)'}, 'Value', '0 (Κανονικό)', ...
    'Position', [150, 247, 230, 28], 'BackgroundColor', [0.25 0.25 0.3], 'FontColor', [1 1 1], 'FontName', 'Segoe UI');

% 3. Vibrato Slider
uilabel(fig, 'Text', 'Τρέμουλο (Vibrato):', 'Position', [35, 210, 120, 22], 'FontColor', [0.9 0.9 0.9], 'FontName', 'Segoe UI', 'FontSize', 13);
vibratoSld = uislider(fig, 'Position', [160, 220, 210, 3], 'Limits', [0 20], 'Value', 0, 'MajorTicks', [], 'MinorTicks', []);

% 4. Glide Slider
uilabel(fig, 'Text', 'Ολίσθηση (Glide):', 'Position', [35, 170, 120, 22], 'FontColor', [0.9 0.9 0.9], 'FontName', 'Segoe UI', 'FontSize', 13);
glideSld = uislider(fig, 'Position', [160, 180, 210, 3], 'Limits', [0 0.97], 'Value', 0.5, 'MajorTicks', [], 'MinorTicks', []);

% --- Κουμπιά Ελέγχου (NATIVE MATLAB BUTTONS - NEO-DARK) ---
recBtn = uibutton(fig, 'push', 'Text', '▶ RECORD', 'Position', [20, 60, 100, 45], ...
    'BackgroundColor', [0.16 0.24 0.18], 'FontColor', [0.4 0.9 0.5], 'FontWeight', 'bold', 'FontName', 'Segoe UI');
pauseBtn = uibutton(fig, 'push', 'Text', '⏸ PAUSE', 'Position', [125, 60, 85, 45], ...
    'BackgroundColor', [0.24 0.18 0.14], 'FontColor', [0.9 0.7 0.4], 'FontWeight', 'bold', 'FontName', 'Segoe UI', 'Enable', 'off');
saveBtn = uibutton(fig, 'push', 'Text', '💾 SAVE', 'Position', [215, 60, 85, 45], ...
    'BackgroundColor', [0.14 0.20 0.26], 'FontColor', [0.4 0.8 1.0], 'FontWeight', 'bold', 'FontName', 'Segoe UI', 'Enable', 'off');
clearBtn = uibutton(fig, 'push', 'Text', '✖ CLEAR', 'Position', [305, 60, 95, 45], ...
    'BackgroundColor', [0.26 0.14 0.14], 'FontColor', [1.0 0.4 0.4], 'FontWeight', 'bold', 'FontName', 'Segoe UI', 'Enable', 'off');

% Κουμπί για το Vocal Trainer 
trainerBtn = uibutton(fig, 'push', 'Text', '🎯 VOCAL TRAINER', 'Position', [20, 110, 380, 35], ...
    'BackgroundColor', [0.15 0.18 0.25], 'FontColor', [0.2 0.9 1.0], 'FontSize', 10, 'FontWeight', 'bold');

% Status Label 
statusLbl = uilabel(fig, 'Text', 'Πατήστε RECORD για να ξεκινήσετε', 'Position', [20, 20, 380, 22], ...
    'FontColor', [0.6 0.6 0.7], 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontName', 'Segoe UI');

% --- "Bubble" 2: Πάνελ Ιστορικού & Playback ---
histBgHtml = ['<html><body style="margin:0; overflow:hidden; background-color:rgb(31,31,41);">', ...
              '<div style="width:100%; height:100%; background:linear-gradient(145deg, #2e2e38, #181821); ', ...
              'border-radius:15px; box-sizing:border-box; border: 1px solid rgb(60,60,70); ', ...
              'box-shadow: 0px 4px 10px rgba(0,0,0,0.2);"></div>', ...
              '</body></html>'];
uihtml(fig, 'Position', [420, 25, 310, 335], 'HTMLSource', histBgHtml);

uilabel(fig, 'Text', '📜 ΙΣΤΟΡΙΚΟ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Segoe UI', ...
    'FontColor', [0.5 0.5 0.6], 'Position', [435, 325, 100, 22]);
playHistBtn = uibutton(fig, 'push', 'Text', '▶ PLAY', 'Position', [635, 323, 80, 26], ...
    'BackgroundColor', [0.16 0.24 0.18], 'FontColor', [0.4 0.9 0.5], 'FontWeight', 'bold', 'FontName', 'Segoe UI');
historyList = uilistbox(fig, 'Position', [435, 40, 280, 275], ...
    'BackgroundColor', [0.15 0.15 0.18], 'FontColor', [0.8 0.8 0.9], ...
    'FontSize', 12, 'FontName', 'Consolas', 'Items', {});

% --- ΕΝΕΡΓΟΠΟΙΗΣΗ ΤΟΥ CUSTOM PROPORTIONAL AUTO-EXPAND ---
ch = fig.Children;
for i = 1:length(ch)
    if isprop(ch(i), 'Position')
        ch(i).UserData = ch(i).Position; % Αποθήκευση αρχικών θέσεων
    end
end
fig.SizeChangedFcn = @(~,~) stretchUI(fig, 750, 440);

% --- Callbacks ---
setappdata(fig, 'appState', 'idle');
recBtn.ButtonPushedFcn = @(btn,event) setappdata(fig, 'appState', 'recording');
pauseBtn.ButtonPushedFcn = @(btn,event) setappdata(fig, 'appState', 'paused');
saveBtn.ButtonPushedFcn = @(btn,event) setappdata(fig, 'appState', 'saving');
clearBtn.ButtonPushedFcn = @(btn,event) setappdata(fig, 'appState', 'clearing');
playHistBtn.ButtonPushedFcn = @(btn,event) playSelectedAudio(historyList.Value);
trainerBtn.ButtonPushedFcn = @(btn,event) openVocalTrainer(fs);

% 3. ΚΥΡΙΟΣ ΒΡΟΧΟΣ ΕΦΑΡΜΟΓΗΣ
micReader = []; speakerWriter = []; recordedAudio = zeros(fs * maxDuration, 1);
recIndex = 1; currentPhase = 0; currentVol = 0; currentFreq = 0; currentVibPhase = 0;
noteSequence = {}; lastNoteRecorded = ''; 

while ishandle(fig)
    state = getappdata(fig, 'appState');
    switch state
        case 'idle'
            pause(0.1); 
            
        case 'recording'
            if isempty(micReader)
                micReader = audioDeviceReader('SampleRate', fs, 'SamplesPerFrame', frameSize);
                speakerWriter = audioDeviceWriter('SampleRate', fs);
                
                recBtn.Enable = 'off'; recBtn.Text = '🔴 RECORDING'; 
                pauseBtn.Enable = 'on'; saveBtn.Enable = 'off'; clearBtn.Enable = 'off'; 
                
                statusLbl.Text = '🔴 Ηχογράφηση...'; statusLbl.FontColor = [1 0.4 0.4];
            end
            audioIn = micReader();
            volumeLevel = norm(audioIn) / sqrt(length(audioIn));
            targetVolume = min(volumeLevel * 5, 1.0);
            
            if targetVolume > 0.05
                f0 = pitch(audioIn, fs, 'Method', 'PEF', 'Range', [60 1500]);
                rawFreq = median(f0);
                if rawFreq > 0 && ~isnan(rawFreq)
                    m_real = round(12 * log2(rawFreq / 440)) + 69; 
                    noteLetter = noteNames{mod(m_real, 12) + 1};
                    octave = num2str(floor(m_real / 12) - 1);
                    currentNoteStr = [noteLetter, octave];
                    
                    if ~strcmp(currentNoteStr, lastNoteRecorded)
                        noteSequence{end+1} = currentNoteStr;
                        lastNoteRecorded = currentNoteStr;
                        statusLbl.Text = ['🔴 Ηχογράφηση... (Τραγουδάς: ', currentNoteStr, ')'];
                    end
                    
                    targetFreq = 440 * (2 ^ ((m_real - 69) / 12));
                    
                    if strcmp(octaveDrop.Value, '-1 (Μπάσο)')
                        targetFreq = targetFreq / 2;
                    elseif strcmp(octaveDrop.Value, '+1 (Πρίμο)')
                        targetFreq = targetFreq * 2;
                    end
                else
                    targetFreq = currentFreq; targetVolume = 0; lastNoteRecorded = ''; 
                end
            else
                targetFreq = currentFreq; targetVolume = 0; lastNoteRecorded = ''; 
            end
            
            if currentFreq == 0 && targetFreq > 0
                currentFreq = targetFreq;
            end
            
            glideFactor = glideSld.Value;
            if targetFreq > 0
                smoothedFreq = (glideFactor * currentFreq) + ((1 - glideFactor) * targetFreq);
            else
                smoothedFreq = 0;
            end
            
            volTrajectory = linspace(currentVol, targetVolume, frameSize)';
            freqTrajectory = linspace(currentFreq, smoothedFreq, frameSize)';
            currentVol = targetVolume; currentFreq = smoothedFreq;
            
            if currentFreq > 0
                vibDepth = vibratoSld.Value; 
                vibRate = 5.5; 
                vibPhaseInc = 2 * pi * vibRate / fs;
                vibPhase = currentVibPhase + (1:frameSize)' * vibPhaseInc;
                currentVibPhase = mod(vibPhase(end), 2*pi);
                
                actualFreqs = freqTrajectory + vibDepth * sin(vibPhase);
                
                phaseInc = 2 * pi * actualFreqs / fs;
                phaseVector = currentPhase + cumsum(phaseInc);
                
                waveType = waveDrop.Value;
                if strcmp(waveType, 'Γλυκό (Ημίτονα)')
                    synthOut = volTrajectory .* (sin(phaseVector) + 0.5 * sin(2 * phaseVector));
                elseif strcmp(waveType, '8-bit (Τετραγωνικό)')
                    synthOut = volTrajectory .* 0.5 .* sign(sin(phaseVector));
                elseif strcmp(waveType, 'Sci-Fi (Πριονωτό)')
                    synthOut = volTrajectory .* 0.5 .* (mod(phaseVector, 2*pi) / pi - 1);
                elseif strcmp(waveType, 'Βιολί (Violin)')
                    harmonics = sin(phaseVector) + ...
                                0.5 * sin(2 * phaseVector) + ...
                                0.3 * sin(3 * phaseVector) + ...
                                0.1 * sin(4 * phaseVector);
                    bowFriction = 0.05 * randn(frameSize, 1);
                    synthOut = volTrajectory .* 0.35 .* (harmonics + bowFriction);
                end
                currentPhase = mod(phaseVector(end), 2*pi);
            else
                synthOut = zeros(frameSize, 1);
                currentPhase = 0;
            end
            
            endIndex = recIndex + frameSize - 1;
            if endIndex <= length(recordedAudio)
                recordedAudio(recIndex:endIndex) = synthOut;
                recIndex = recIndex + frameSize;
            else
                setappdata(fig, 'appState', 'paused'); 
            end
            
            speakerWriter(synthOut);
            drawnow limitrate;
        case 'paused'
            if ~isempty(micReader)
                release(micReader); release(speakerWriter);
                micReader = []; speakerWriter = [];
                
                recBtn.Enable = 'on'; recBtn.Text = '▶ CONTINUE'; 
                pauseBtn.Enable = 'off'; saveBtn.Enable = 'on'; clearBtn.Enable = 'on'; 
                
                statusLbl.Text = '⏸ Παύση (Continue, Save ή Clear)'; 
                statusLbl.FontColor = [0.9 0.6 0.2];
                lastNoteRecorded = ''; 
            end
            pause(0.1);
            drawnow;
        case 'saving'
            statusLbl.Text = '💾 Αποθήκευση...'; 
            statusLbl.FontColor = [0.2 0.5 0.9];
            drawnow;
            if recIndex > 1
                finalAudio = recordedAudio(1:recIndex-1);
                timestamp = char(datetime('now', 'Format', 'yyyyMMdd_HHmmss'));
                shortName = ['VS_', timestamp, '.wav']; 
                
                audiowrite(shortName, finalAudio, fs);
                
                notesString = strjoin(noteSequence, '-');
                if isempty(notesString)
                    notesString = '(Χωρίς νότες)';
                end
                
                historyEntry = sprintf('%s | %s', shortName, notesString);
                
                currentItems = historyList.Items;
                historyList.Items = [historyEntry, currentItems];
                
                statusLbl.Text = ['Αποθηκεύτηκε ως: ', shortName]; 
                statusLbl.FontColor = [0.2 0.8 0.2];
            end
            
            noteSequence = {};
            setappdata(fig, 'appState', 'paused');
        case 'clearing'
            recordedAudio = zeros(fs * maxDuration, 1);
            recIndex = 1; currentPhase = 0; currentVol = 0; currentFreq = 0;
            noteSequence = {}; lastNoteRecorded = ''; 
            
            statusLbl.Text = '🗑️ Η μνήμη καθάρισε!'; 
            statusLbl.FontColor = [0.7 0.7 0.7];
            
            recBtn.Enable = 'on'; recBtn.Text = '▶ RECORD'; 
            pauseBtn.Enable = 'off'; saveBtn.Enable = 'off'; clearBtn.Enable = 'off';
            
            setappdata(fig, 'appState', 'idle');
    end
end
if ~isempty(micReader)
    release(micReader); release(speakerWriter);
end

% --- ΤΟΠΙΚΕΣ ΣΥΝΑΡΤΗΣΕΙΣ ---
function playSelectedAudio(selectedValue)
    if isempty(selectedValue), return; end
    parts = strsplit(selectedValue, ' | ');
    filename = strtrim(parts{1});
    if exist(filename, 'file')
        [y, fs_f] = audioread(filename);
        clear sound; 
        sound(y, fs_f);
    else
        disp(['Σφάλμα: Το αρχείο ', filename, ' δεν βρέθηκε.']);
    end
end

function openVocalTrainer(fs)
    % Κλείνουμε το AutoResize και εδώ
    trainFig = uifigure('Name', 'Vocal Trainer', 'Position', [500, 400, 400, 300], ...
        'Color', [0.15 0.15 0.18], 'AutoResizeChildren', 'off');
    
    uilabel(trainFig, 'Text', 'Στόχος:', 'Position', [20, 250, 50, 22], 'FontColor', [1 1 1]);
    targetNoteDrop = uidropdown(trainFig, 'Items', ...
        {'C2','G2','C3','G3','C4','G4','C5','D5','E5','F5','G5','A5','B5','C6'}, ...
        'Value', 'C4', 'Position', [80, 247, 120, 28]);
    
    listenBtn = uibutton(trainFig, 'push', 'Text', '🔊 LISTEN', 'Position', [220, 247, 120, 28], ...
        'BackgroundColor', [0.2 0.2 0.25], 'FontColor', [0.6 0.7 0.9], 'FontWeight', 'bold');
    
    htmlStr = ['<html><body style="margin:0; background-color:rgb(38,38,46); display:flex; align-items:center; justify-content:center; height:100vh; overflow:hidden;">', ...
               '<div id="orb" style="width:36px; height:36px; border-radius:50%; ', ...
               'background: radial-gradient(circle at 30% 30%, #666, #222); ', ...
               'box-shadow: 0 0 15px #666; ', ...
               'animation: pulse 1.2s infinite alternate; transition: background 0.2s, box-shadow 0.2s;"></div>', ...
               '<style>@keyframes pulse {0% {transform: scale(0.85); opacity: 0.8;} 100% {transform: scale(1.15); opacity: 1;}}</style>', ...
               '<script type="text/javascript">', ...
               'function setup(htmlComponent) {', ...
               '  htmlComponent.addEventListener("DataChanged", function(event) {', ...
               '    var c = event.Data;', ...
               '    var el = document.getElementById("orb");', ...
               '    el.style.background = "radial-gradient(circle at 30% 30%, " + c[0] + ", " + c[1] + ")";', ...
               '    el.style.boxShadow = "0 0 25px " + c[0];', ...
               '  });', ...
               '}', ...
               '</script></body></html>'];
           
    feedbackLamp = uihtml(trainFig, 'Position', [150, 115, 100, 100], 'HTMLSource', htmlStr);
    
    feedbackLbl = uilabel(trainFig, 'Text', 'Περιμένω...', 'Position', [20, 110, 360, 22], 'HorizontalAlignment', 'center', 'FontColor', [1 1 1], 'FontSize', 14);
    
    testBtn = uibutton(trainFig, 'state', 'Text', 'START TEST', 'Position', [125, 30, 150, 50], ...
        'BackgroundColor', [0.14 0.20 0.26], 'FontColor', [0.4 0.8 1.0], 'FontWeight', 'bold');
    
    % Προσαρμοσμένο Proportional Scaling για το παράθυρο του Trainer
    ch2 = trainFig.Children;
    for i = 1:length(ch2)
        if isprop(ch2(i), 'Position')
            ch2(i).UserData = ch2(i).Position;
        end
    end
    trainFig.SizeChangedFcn = @(~,~) stretchUI(trainFig, 400, 300);

    notes = {'C2','C#2','D2','D#2','E2','F2','F#2','G2','G#2','A2','A#2','B2',...
             'C3','C#3','D3','D#3','E3','F3','F#3','G3','G#3','A3','A#3','B3',...
             'C4','C#4','D4','D#4','E4','F4','F#4','G4','G#4','A4','A#4','B4',...
             'C5','C#5','D5','D#5','E5','F5','F#5','G5','G#5','A5','A#5','B5','C6'};
    midiValues = 36:84; 
    
    listenBtn.ButtonPushedFcn = @(btn,event) playReferencePitch(targetNoteDrop.Value, notes, midiValues, fs);
    trainMic = audioDeviceReader('SampleRate', fs, 'SamplesPerFrame', 2048);
    
    while ishandle(trainFig)
        if testBtn.Value == 1
            if strcmp(testBtn.Text, 'START TEST')
                testBtn.Text = 'STOP';
                testBtn.BackgroundColor = [0.26 0.14 0.14];
                testBtn.FontColor = [1.0 0.4 0.4];
            end
            
            audioIn = trainMic();
            
            f0 = pitch(audioIn, fs, 'Method', 'NCF', 'Range', [50 1600]);
            f0 = f0(~isnan(f0));
            
            if ~isempty(f0)
                currentF = median(f0);
                m_voice = 12 * log2(currentF / 440) + 69;
                idx = strcmp(notes, targetNoteDrop.Value);
                m_target = midiValues(idx);
                diff = abs(m_voice - m_target);
                
                cGreen  = [0.2, 0.9, 0.2]; 
                cOrange = [1.0, 0.6, 0.0]; 
                cRed    = [0.9, 0.2, 0.2]; 
                
                if diff <= 0.4 
                    liveC = cGreen;
                    feedbackLbl.Text = sprintf('ΣΩΣΤΟΣ! (Απόκλιση: %.2f)', diff);
                elseif diff <= 1.0
                    t = (diff - 0.4) / (1.0 - 0.4); 
                    liveC = (1 - t) * cGreen + t * cOrange;
                    feedbackLbl.Text = 'Κοντά είσαι...';
                else
                    if diff <= 2.0
                        t = (diff - 1.0) / (2.0 - 1.0);
                        liveC = (1 - t) * cOrange + t * cRed;
                    else
                        liveC = cRed;
                    end
                    feedbackLbl.Text = 'Λάθος νότα.';
                end
                
                r = round(liveC(1)*255); g = round(liveC(2)*255); b = round(liveC(3)*255);
                cLight = sprintf('rgba(%d,%d,%d,1)', min(r+80,255), min(g+80,255), min(b+80,255));
                cDark  = sprintf('rgba(%d,%d,%d,1)', max(r-60,0), max(g-60,0), max(b-60,0));
                
                feedbackLamp.Data = {cLight, cDark};
                
            else
                feedbackLamp.Data = {'rgba(100,100,100,1)', 'rgba(34,34,34,1)'};
                feedbackLbl.Text = 'Σιωπή...';
            end
            drawnow limitrate; 
            
        else
            if strcmp(testBtn.Text, 'STOP')
                testBtn.Text = 'START TEST';
                testBtn.BackgroundColor = [0.14 0.20 0.26];
                testBtn.FontColor = [0.4 0.8 1.0];
            end
            drawnow limitrate;
        end
    end
    release(trainMic);
end

function playReferencePitch(targetStr, notes, midiValues, fs)
    idx = strcmp(notes, targetStr);
    m_target = midiValues(idx);
    freq = 440 * 2^((m_target-69)/12);
    
    t = 0:1/fs:0.8; 
    fade = [linspace(0,1,fs*0.1), ones(1, length(t)-fs*0.2), linspace(1,0,fs*0.1)]; 
    
    fundamental = sin(2 * pi * freq * t(1:length(fade)));
    harmonic2   = 0.50 * sin(2 * pi * (2*freq) * t(1:length(fade))); 
    harmonic3   = 0.25 * sin(2 * pi * (3*freq) * t(1:length(fade))); 
    
    richTone = fundamental + harmonic2 + harmonic3;
    s = 0.2 * richTone .* fade; 
    
    sound(s, fs);
end

% --- Η ΜΑΓΙΚΗ ΣΥΝΑΡΤΗΣΗ ΠΟΥ ΑΝΑΛΑΜΒΑΝΕΙ ΤΟ ΤΕΛΕΙΟ STRETCHING ---
function stretchUI(f, baseW, baseH)
    % Υπολογισμός ποσοστού μεγέθυνσης
    scaleX = f.Position(3) / baseW;
    scaleY = f.Position(4) / baseH;
    
    % Εφαρμογή της μεγέθυνσης σε κάθε στοιχείο ξεχωριστά!
    ch = f.Children;
    for i = 1:length(ch)
        if isprop(ch(i), 'Position') && ~isempty(ch(i).UserData)
            origPos = ch(i).UserData;
            ch(i).Position = [origPos(1)*scaleX, origPos(2)*scaleY, origPos(3)*scaleX, origPos(4)*scaleY];
        end
    end
end
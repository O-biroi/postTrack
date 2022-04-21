hexMap = {'2596be', 'e28743', '873e23'}
myColorMap = zeros(length(hexMap), 3); % Preallocate
for k = 1 : length(hexMap)
	thisCell = hexMap{k}
	r = hex2dec(thisCell(1:2))
	g = hex2dec(thisCell(3:4))
	b = hex2dec(thisCell(5:6))
	myColorMap(k, :) = [r, g, b]
end
myColorMap = myColorMap / 255; % Normalize to range 0-1

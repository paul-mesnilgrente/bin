function [] = saveallfigs(folder, format)
    h = sort(get(0, 'Children'));
    for i = 1:size(h)
        saveas(h(i), [folder '/' 'figure' num2str(i)], format);
    end
end

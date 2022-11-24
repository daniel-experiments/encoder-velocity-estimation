function latex_str = to_latex(plain_strings)
    plain_strings = convertStringsToChars(plain_strings);
    latex_str = plain_strings;
    
    % add { after first subscript marker '_' in a word
    latex_str = insertAfter(latex_str, regexpPattern('(^|\s+)[^_\W]+_(?=[^_\W])'), '{'); 

    % add } after each word that contains a {
    latex_str = insertAfter(latex_str, regexpPattern('{\w+(?=\s|$)'), '}');

    % escape \ characters
    latex_str = insertAfter(latex_str, regexpPattern('(?=\\)'), '\');

    % escape % characters
    latex_str = insertAfter(latex_str, regexpPattern('(?=%)'), '\');

    % escape _ characters that are not followed by a {
    latex_str = insertAfter(latex_str, regexpPattern('(?=_[^\{])'), '\');

    % put $ around whole string
    latex_str = ['$ ', latex_str, ' $'];
end

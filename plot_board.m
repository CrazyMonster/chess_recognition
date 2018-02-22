function plot_board(image, tform, fen)
    s1 = subplot(1, 2, 1);
    cla(s1); hold on;
    
    title(fen); axis tight;
    imshow(image);
    
    corners = transformPointsInverse(tform, [0 0; 1 0; 1 1; 0 1; 0 0]);
    
    plot(corners(:, 1), corners(:, 2), 'LineWidth', 2, 'Color', 'green');
    plot(corners(:, 1), corners(:, 2), 'x', 'Color', 'red');
    
    hold off;
    
    s2 = subplot(1, 2, 2);
    cla(s2); axis off;
    
    board = board_info(fen);
    pieces = merida_keymap(board);
    
    text(0.5, 0.5, pieces, ...
         'FontName', 'Chess Merida', 'FontSize', 40, ...
         'Units', 'normalized', 'HorizontalAlignment', 'center', ...
         'BackgroundColor', 'white');
     
    hold off;
end

function out = merida_keymap(board)
    pieces = reshape([board.Piece], 8, 8);
    is_white = [board.IsWhite];
    is_empty = [board.IsEmpty];
    
    out = pieces;
    
    out(pieces == 'p') = 'o';
    out(pieces == 'n') = 'm';
    out(pieces == 'b') = 'v';
    out(pieces == 'r') = 't';
    out(pieces == 'q') = 'w';
    out(pieces == 'k') = 'l';

    out(is_white) = lower(out(is_white));
    out(~is_white) = upper(out(~is_white));

    out(is_empty & ~is_white) = '+';
    
    top =    ['1',               repmat('2', 1, 8),               '3'];
    middle = [repmat('4', 8, 1), out,               repmat('5', 8, 1)];
    bottom = ['7',               repmat('8', 1, 8),               '9'];
    
    out = [top; middle; bottom];
end
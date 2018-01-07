function out=compute_ghist(image)
  
  h = imhist(image);
  
  out = h' / sum(h(:));
    
end
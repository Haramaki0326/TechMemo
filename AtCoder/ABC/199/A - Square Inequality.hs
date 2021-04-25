main :: IO()

main = do
 [a,b,c] <- map read . words <$> getLine
 if (a ^ 2) + (b ^ 2) < c ^ 2 then putStrLn "Yes" else putStrLn "No"
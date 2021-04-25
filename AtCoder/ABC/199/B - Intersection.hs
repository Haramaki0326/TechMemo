import Data.List

f :: (Num a, Enum a) => (a,a) -> [a]
f x = [fst x .. snd x]

main :: IO()

main = do
 getLine
 a <- map read . words <$> getLine
 b <- map read . words <$> getLine

 print $ length $ foldl1 intersect $ map f $ zip (a :: [Int]) (b  :: [Int])

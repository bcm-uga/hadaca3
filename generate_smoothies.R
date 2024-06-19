set.seed(1)

# fruit profiles matrix
fruit_refs = rbind(
  vitA=log2(rpois(10, 100)   ),
  vitB=log2(rpois(10, 200)   ),
  vitC=log2(rpois(10, 300)   ),
  vitD=log2(rpois(10, 500)   ),
  vitE=log2(rpois(10, 1000)  ),
  vitF=log2(rpois(10, 2000)  ),
  vitG=log2(rpois(10, 3000)  ),
  vitH=log2(rpois(10, 5000)  ),
  vitI=log2(rpois(10, 10000) ),
  vitJ=log2(rpois(10, 20000) ),
  vitK=log2(rpois(10, 30000) ),
  vitL=log2(rpois(10, 50000) ),
  vitM=log2(rpois(10, 100000)),
  vitN=log2(rpois(10, 200000)),
  vitO=log2(rpois(10, 300000)),
  vitP=log2(rpois(10, 500000))
)
colnames(fruit_refs) = c("Apple", "Banan", "Orang", "Grape", "Mango", "Straw","Pinea", "Blueb", "Water", "Peach")


# fruit proportion matrix
recipes = sapply(paste0("recipe", 1:10), function(recipe) {
  foo = c(sort(runif(ncol(fruit_refs)-1)),1)
  prop = c(foo[1], foo[-1] - foo[-length(foo)])
  sum(prop) 
  prop
})
rownames(recipes) = colnames(fruit_refs)

# check that for each recipe the sum of proporttion is equal to 1
apply(recipes, 2, sum)

# generate smoothies as combination of fruits and recipes and gaussian error
smoothies = fruit_refs %*% recipes# + rpois(10, lambda = 0.5))
error = t(sapply(.1*apply(smoothies, 1, sd), rnorm, n=ncol(smoothies), mean=0))
smoothies = smoothies + error

# predict recipes
predicted_recipes = apply(
  X = smoothies,
  MARGIN = 2,
  FUN = nnls::nnls,
  A = fruit_refs
)

predicted_recipes = lapply(predicted_recipes, function(m) m$x)
predicted_recipes = lapply(predicted_recipes, function(b) {b/sum(b)})
predicted_recipes = do.call(cbind, predicted_recipes)


rmse = sqrt(mean((predicted_recipes - recipes)^2))
rmse
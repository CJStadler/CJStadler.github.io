```rb
def contains_dog?(arr)
  for e in arr
    if e == "dog"
      return true
    end
  end

  false
end

def contains_cat?(arr)
  if arr.empty?
    false
  else
    first, *rest = arr

    first == "cat" || contains_cat?(rest)
  end
end

puts contains_dog?(["hello", "world", "dog"])
puts !contains_dog?(["hello"])

puts contains_cat?(["hello", "world", "cat"])
puts !contains_cat?(["hello"])
```

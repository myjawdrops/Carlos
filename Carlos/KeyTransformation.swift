import Foundation

/**
Applies a transformation to a cache closure
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: fetchClosure The cache closure you want to transform
:param: transformer The transformation you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func transformKeys<A, B: OneWayTransformer>(transformer: B, fetchClosure: (key: B.TypeOut) -> CacheRequest<A>) -> BasicCache<B.TypeIn, A> {
  return transformKeys(transformer, wrapClosureIntoCacheLevel(fetchClosure))
}

/**
Applies a transformation to a cache closure
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: fetchClosure The cache closure you want to transform
:param: transformerClosure The transformation closure you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func transformKeys<A, B, C>(transformerClosure: C -> A?, fetchClosure: (key: A) -> CacheRequest<B>) -> BasicCache<C, B> {
  return transformKeys(wrapClosureIntoOneWayTransformer(transformerClosure), wrapClosureIntoCacheLevel(fetchClosure))
}

/**
Applies a transformation to a cache level
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: cache The cache level you want to transform
:param: transformer The transformation you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func transformKeys<A: CacheLevel, B: OneWayTransformer where A.KeyType == B.TypeOut>(transformer: B, cache: A) -> BasicCache<B.TypeIn, A.OutputType> {
  return BasicCache(
    getClosure: { key in
      if let transformedKey = transformer.transform(key) {
        return cache.get(transformedKey)
      } else {
        let request = CacheRequest<A.OutputType>()
        request.fail(errorWithCode(FetchError.KeyTransformationFailed.rawValue))
        return request
      }
    }, setClosure: { (key, value) in
      if let transformedKey = transformer.transform(key) {
        cache.set(value, forKey: transformedKey)
      }
    }, clearClosure: {
      cache.clear()
    }, memoryClosure: {
      cache.onMemoryWarning()
    }
  )
}

/**
Applies a transformation to a cache level
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: cache The cache level you want to transform
:param: transformerClosure The transformation closure you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func transformKeys<A: CacheLevel, B>(transformerClosure: B -> A.KeyType?, cache: A) -> BasicCache<B, A.OutputType> {
  return transformKeys(wrapClosureIntoOneWayTransformer(transformerClosure), cache)
}

/**
Applies a transformation to a cache closure
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: fetchClosure The cache closure you want to transform
:param: transformer The transformation you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func =>><A, B: OneWayTransformer>(transformer: B, fetchClosure: (key: B.TypeOut) -> CacheRequest<A>) -> BasicCache<B.TypeIn, A> {
  return transformKeys(transformer, wrapClosureIntoCacheLevel(fetchClosure))
}

/**
Applies a transformation to a cache closure
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: fetchClosure The cache closure you want to transform
:param: transformerClosure The transformation closure you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func =>><A, B, C>(transformerClosure: C -> A?, fetchClosure: (key: A) -> CacheRequest<B>) -> BasicCache<C, B> {
  return transformKeys(wrapClosureIntoOneWayTransformer(transformerClosure), wrapClosureIntoCacheLevel(fetchClosure))
}

/**
Applies a transformation to a cache level
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: cache The cache level you want to transform
:param: transformer The transformation you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func =>><A: CacheLevel, B: OneWayTransformer where A.KeyType == B.TypeOut>(transformer: B, cache: A) -> BasicCache<B.TypeIn, A.OutputType> {
  return transformKeys(transformer, cache)
}

/**
Applies a transformation to a cache level
The transformation works by changing the type of the key the cache accepts
Use this transformation when you use a domain specific key or a wrapper key that contains several values every cache level can choose from

:param: cache The cache level you want to transform
:param: transformerClosure The transformation closure you want to apply

:returns: A new cache level result of the transformation of the original cache level
*/
public func =>><A: CacheLevel, B>(transformerClosure: B -> A.KeyType?, cache: A) -> BasicCache<B, A.OutputType> {
  return transformKeys(wrapClosureIntoOneWayTransformer(transformerClosure), cache)
}

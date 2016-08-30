using System;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    public static class StatefulStorageExtensions
    {
        public static TValue Get<TValue>(this IStatefulStorage storage)
        {
            return storage.Get<TValue>(name: null);
        }

        public static TValue GetOrAdd<TValue>(this IStatefulStorage storage, Func<TValue> valueFactory)
        {
            return storage.GetOrAdd<TValue>(name: null, valueFactory: valueFactory);
        }
    }
}

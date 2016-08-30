using System;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    public interface IStatefulStorage
    {
        TValue Get<TValue>(string name);
        TValue GetOrAdd<TValue>(string name, Func<TValue> valueFactory);
    }
}

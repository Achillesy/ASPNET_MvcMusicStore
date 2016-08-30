using System;
using System.Collections;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    public abstract class DictionaryStatefulStorage : IStatefulStorage
    {
        private Func<string, object> getter;
        private Action<string, object> setter;

        protected DictionaryStatefulStorage(Func<IDictionary> dictionaryAccessor)
        {
            getter = key => dictionaryAccessor()[key];
            setter = (key, value) => dictionaryAccessor()[key] = value;
        }

        protected DictionaryStatefulStorage(Func<string, object> getter, Action<string, object> setter)
        {
            this.getter = getter;
            this.setter = setter;
        }

        protected static string FullNameOf(Type type, string name)
        {
            string fullName = type.FullName;
            if (!String.IsNullOrWhiteSpace(name))
                fullName += "::" + name;
            return fullName;
        }

        public TValue Get<TValue>(string name)
        {
            return (TValue)getter(FullNameOf(typeof(TValue), name));
        }

        public TValue GetOrAdd<TValue>(string name, Func<TValue> valueFactory)
        {
            string fullName = FullNameOf(typeof(TValue), name);
            TValue result = (TValue)getter(fullName);

            if (Object.Equals(result, default(TValue)))
            {
                result = valueFactory();
                setter(fullName, result);
            }

            return result;
        }
    }
}

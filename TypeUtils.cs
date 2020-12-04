using System;
using System.Reflection;
using System.Collections.Generic;
using System.Management.Automation;

namespace PowerSharp
{
    public class TypeAccel
    {
        public static Type Type = typeof(PowerShell).Assembly.GetType($"{typeof(PowerShell).Namespace}.TypeAccelerators");
        public static PropertyInfo AccelMember = (PropertyInfo)Type.GetMember("Get")[0];
        public static MethodInfo AddMethod => Type.GetMethod("Add");
        public static Dictionary<string, Type> Aliases => (Dictionary<string, Type>)AccelMember.GetValue(null);

        public static bool Add(string alias, Type type)
        {
            // Turns out, if you try to "overwrite" an existing alias, you it will update it in the aliases dictionary, but it will _not_ actually change the reference to it.
            if (Aliases.ContainsKey(alias))
            {
                Console.WriteLine($"The alias '{alias}' was already defined, for the type [{Aliases[alias]}].\nThe internet CLAIMS that it should be overwritten with the new type, [{type}], but that doesn't appear to be the case. So, to prevent confusion, we're going to exit this call.");
            }

            AddMethod.Invoke(null, new Object[] { alias, type });
            return false;
        }
    }
}
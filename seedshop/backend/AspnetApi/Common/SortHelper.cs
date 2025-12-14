using System.Linq.Expressions;

namespace AspnetApi.Common
{
    public class SortHelper
    {
        public static IQueryable<T> ApplySorting<T>(IQueryable<T> source, string sortBy, bool isAscending)
        {
            // Ensure the property name is valid
            var propertyInfo = typeof(T).GetProperty(sortBy);
            if (propertyInfo == null)
            {
                throw new ArgumentException($"Property '{sortBy}' does not exist on type '{typeof(T).Name}'.");
            }

            // Create the expression: item => item.SortBy
            var parameter = Expression.Parameter(typeof(T), "item");
            var property = Expression.Property(parameter, propertyInfo.Name);
            var sortExpression = Expression.Lambda(property, parameter);

            // Create the method call expression for OrderBy or OrderByDescending
            var method = isAscending ? "OrderBy" : "OrderByDescending";
            var expression = Expression.Call(
                typeof(Queryable),
                method,
                new Type[] { typeof(T), propertyInfo.PropertyType },
                source.Expression,
                Expression.Quote(sortExpression)
            );

            // Apply the sorting to the source query
            return source.Provider.CreateQuery<T>(expression);
        }
    }
}

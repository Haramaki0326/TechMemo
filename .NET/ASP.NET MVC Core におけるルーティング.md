# ASP.NET Core MVC におけるルーティング
## エンドポイント（ASP.NET Core 3.0以降）
`ASP.NET Core 3.0`以降では、ルーティングにはエンドポイント (Endpoint) を使用して、アプリの論理エンドポイントを表します。

#### Routeクラス（ASP.NET Core 2.2以前）
※`ASP.NET Core 2.2`以前では`IRouter`の標準実装として`Route` クラスが与えられ、それを用いて設定を行う。
`2.2`以前と`3.0`以降との違いは以下
[エンドポイント ルーティングと以前のバージョンのルーティングとの相違点](https://docs.microsoft.com/ja-jp/aspnet/core/fundamentals/routing?view=aspnetcore-3.1#endpoint-routing-differences-from-earlier-versions-of-routing)
[スタートアップコードのルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/migration/22-to-30?view=aspnetcore-3.1&tabs=visual-studio#routing-startup-code)

## サンプルコード
VisualStudioからMVCを選んで自動生成される`Program.cs`、`Startup.cs`は以下。
`Program.cs`
``` cs
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;

namespace SampleNetCoreMVC
{
	public class Program
	{
		public static void Main(string[] args)
		{
			CreateHostBuilder(args).Build().Run();
		}

		public static IHostBuilder CreateHostBuilder(string[] args) =>
			Host.CreateDefaultBuilder(args)
				.ConfigureWebHostDefaults(webBuilder =>
				{
					webBuilder.UseStartup<Startup>();
				});
	}
}
```

`Startup.cs`
``` cs
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace SampleNetCoreMVC
{
	public class Startup
	{
		public Startup(IConfiguration configuration)
		{
			Configuration = configuration;
		}

		public IConfiguration Configuration { get; }

		// This method gets called by the runtime. Use this method to add services to the container.
		public void ConfigureServices(IServiceCollection services)
		{
			services.AddControllersWithViews();
		}

		// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
		public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
		{
			if (env.IsDevelopment())
			{
				app.UseDeveloperExceptionPage();
			}
			else
			{
				app.UseExceptionHandler("/Home/Error");
				// The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
				app.UseHsts();
			}
			app.UseHttpsRedirection();
			app.UseStaticFiles();

			app.UseRouting();

			app.UseAuthorization();

			app.UseEndpoints(endpoints =>
			{
				endpoints.MapControllerRoute(
					name: "default",
					pattern: "{controller=Home}/{action=Index}/{id?}");
			});
		}
	}
}
```

## 概要
[ASP.NET Core のルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/fundamentals/routing?view=aspnetcore-3.1)
[エンドポイント ルーティング](https://docs.microsoft.com/ja-jp/aspnet/core/fundamentals/routing?view=aspnetcore-3.1#endpoint-routing)
[ASP.NET Core Web アプリケーションでルーティング機能を利用しエンドポイントの作成をする](https://www.ipentec.com/document/csharp-asp-net-core-create-endpoints)
[ASP.NET Core Web アプリケーションでコントローラーへのルーティング、マッピングを作成する](https://www.ipentec.com/document/csharp-asp-net-core-create-map-route-controller-using-endpoints)
- エンドポイント ルーティングは、次の 2 つの拡張メソッドを使ってミドルウェアと統合されます。
    - `UseRouting` により、ミドルウェア パイプラインにルート照合が追加されます。 これは、承認やエンドポイントの実行など、ルート対応のあらゆるミドルウェアの前に配置する必要があります。
    - `UseEndpoints` により、ミドルウェア パイプラインにエンドポイントの実行が追加されます。 これにより、エンドポイントの応答を提供する要求デリゲートが実行されます。 また、UseEndpoints は、アプリによって照合および実行できるルート エンドポイントが構成される場所でもあります。 
      - たとえば、`MapRazorPages`、`MapControllers`、`MapGet`、`MapPost` などです。
- アプリでは、そのルートを構成するために、ASP.NET Core のヘルパー メソッドが使用されます。 
    - ASP.NET Core フレームワークには、`MapRazorPages`、`MapControllers`、`MapHub<THub>` などのヘルパー メソッドが用意されています。 
    - 独自のカスタム ルート エンドポイントを構成するためのヘルパーメソッドもあります。`MapGet`、`MapPost`、および `MapVerb` です。


## 規則ルーティング

次の表は、ルート テンプレートの例とその動作をまとめたものです。

|ルートテンプレート|一致するURIの例|要求URI…|
|---|---|---|
|`hello`|`/hello`|	単一パス `/hello` にのみ一致します。|
|`{Page=Home}`|	`/`|	一致し、`Page` が `Home` に設定されます。|
|`{Page=Home}`|	`/Contact`|	一致し、`Page` が `Contact` に設定されます。|
|`{controller}/{action}/{id?}`|	`/Products/List`|	`Products` コントローラーと `List` アクションにマッピングされます。|
|`{controller}/{action}/{id?}`|	`/Products/Details/123`|	`Products` コントローラーと `Details` アクションにマッピングされます (id は 123 に設定されます)。|
|`{controller=Home}/{action=Index}/{id?}`|`/`|	`Home` コントローラーと `Index` メソッドにマッピングされます (id は無視されます)。|

## 属性ルーティング


## 実際の実装
ASP.NET Coreの内部実装はGitHubで公開している。以下は`MapControllerRoute`の実装

<details>
<summary>GitHubでの実際のコード</summary>

- [ControllerEndpointRouteBuilderExtensions.MapControllerRoute](https://docs.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.builder.controllerendpointroutebuilderextensions.mapcontrollerroute?view=aspnetcore-3.1)
- [ControllerEndpointRouteBuilderExtensions.cs](https://github.com/dotnet/aspnetcore/blob/6ce8a879ae10e9f27798ec6e1c577092413f813d/src/Mvc/Mvc.Core/src/Builder/ControllerEndpointRouteBuilderExtensions.cs)
- [IEndpointRouteBuilder.cs](https://github.com/dotnet/aspnetcore/blob/133a7e0414ffeb6af54093bb678afb3d401248e0/src/Http/Routing/src/IEndpointRouteBuilder.cs)
- [ControllerActionEndpointDataSource.cs](https://github.com/dotnet/aspnetcore/blob/6ce8a879ae10e9f27798ec6e1c577092413f813d/src/Mvc/Mvc.Core/src/Routing/ControllerActionEndpointDataSource.cs)
- [ConventionalRouteEntry.cs](https://github.com/dotnet/aspnetcore/blob/6a99743d337d205bdf78333cfaac33db993c1034/src/Mvc/Mvc.Core/src/Routing/ConventionalRouteEntry.cs)
- [RoutePatternFactory.cs](https://github.com/dotnet/aspnetcore/blob/c7f05c614ab7ecb1ff8331287fe050d322f10b2e/src/Http/Routing/src/Patterns/RoutePatternFactory.cs)
- [RoutePatternParser.cs](https://github.com/dotnet/aspnetcore/blob/19c9010c2fc44f6fa3952c3f46d1b6e86e45fa8c/src/Http/Routing/src/Patterns/RoutePatternParser.cs)

### MapControllerRoute
``` cs
public static ControllerActionEndpointConventionBuilder MapControllerRoute(
            this IEndpointRouteBuilder endpoints,
            string name,
            string pattern,
            object defaults = null,
            object constraints = null,
            object dataTokens = null)
        {
            if (endpoints == null)
            {
                throw new ArgumentNullException(nameof(endpoints));
            }

            EnsureControllerServices(endpoints);

            var dataSource = GetOrCreateDataSource(endpoints);
            return dataSource.AddRoute(
                name,
                pattern,
                new RouteValueDictionary(defaults),
                new RouteValueDictionary(constraints),
                new RouteValueDictionary(dataTokens));
        }
```

``` cs
private static ControllerActionEndpointDataSource GetOrCreateDataSource(IEndpointRouteBuilder endpoints)
        {
            var dataSource = endpoints.DataSources.OfType<ControllerActionEndpointDataSource>().FirstOrDefault();
            if (dataSource == null)
            {
                dataSource = endpoints.ServiceProvider.GetRequiredService<ControllerActionEndpointDataSource>();
                endpoints.DataSources.Add(dataSource);
            }

            return dataSource;
        }
```

### IEndpointRouteBuilder
``` cs
    public interface IEndpointRouteBuilder
    {
        /// <summary>
        /// Creates a new <see cref="IApplicationBuilder"/>.
        /// </summary>
        /// <returns>The new <see cref="IApplicationBuilder"/>.</returns>
        IApplicationBuilder CreateApplicationBuilder();

        /// <summary>
        /// Gets the sets the <see cref="IServiceProvider"/> used to resolve services for routes.
        /// </summary>
        IServiceProvider ServiceProvider { get; }

        /// <summary>
        /// Gets the endpoint data sources configured in the builder.
        /// </summary>
        ICollection<EndpointDataSource> DataSources { get; }
    }
```


### ControllerActionEndpointDataSource
``` cs
public ControllerActionEndpointConventionBuilder AddRoute(
            string routeName,
            string pattern,
            RouteValueDictionary defaults,
            IDictionary<string, object> constraints,
            RouteValueDictionary dataTokens)
        {
            lock (Lock)
            {
                var conventions = new List<Action<EndpointBuilder>>();
                _routes.Add(new ConventionalRouteEntry(routeName, pattern, defaults, constraints, dataTokens, _order++, conventions));
                return new ControllerActionEndpointConventionBuilder(Lock, conventions);
            }
        }
```

### ConventionalRouteEntry
``` cs
internal readonly struct ConventionalRouteEntry
    {
        public readonly RoutePattern Pattern;
        public readonly string RouteName;
        public readonly RouteValueDictionary DataTokens;
        public readonly int Order;
        public readonly IReadOnlyList<Action<EndpointBuilder>> Conventions;

        public ConventionalRouteEntry(
            string routeName,
            string pattern,
            RouteValueDictionary defaults,
            IDictionary<string, object> constraints,
            RouteValueDictionary dataTokens,
            int order,
            List<Action<EndpointBuilder>> conventions)
        {
            RouteName = routeName;
            DataTokens = dataTokens;
            Order = order;
            Conventions = conventions;

            try
            {
                // Data we parse from the pattern will be used to fill in the rest of the constraints or
                // defaults. The parser will throw for invalid routes.
                Pattern = RoutePatternFactory.Parse(pattern, defaults, constraints);
            }
            catch (Exception exception)
            {
                throw new RouteCreationException(string.Format(
                    CultureInfo.CurrentCulture, 
                    "An error occurred while creating the route with name '{0}' and pattern '{1}'.", 
                    routeName, 
                    pattern), exception);
            }
        }
    }
```

### RoutePatternFactory
``` cs
public static RoutePattern Parse(string pattern, object defaults, object parameterPolicies)
        {
            if (pattern == null)
            {
                throw new ArgumentNullException(nameof(pattern));
            }

            var original = RoutePatternParser.Parse(pattern);
            return PatternCore(original.RawText, Wrap(defaults), Wrap(parameterPolicies), requiredValues: null, original.PathSegments);
        }
```

``` cs
        public static RoutePattern Pattern(string rawText, IEnumerable<RoutePatternPathSegment> segments)
        {
            if (segments == null)
            {
                throw new ArgumentNullException(nameof(segments));
            }

            return PatternCore(rawText, null, null, null, segments);
        }
```

``` cs
        private static RoutePattern PatternCore(
            string rawText,
            RouteValueDictionary defaults,
            RouteValueDictionary parameterPolicies,
            RouteValueDictionary requiredValues,
            IEnumerable<RoutePatternPathSegment> segments)
        {
            // We want to merge the segment data with the 'out of line' defaults and parameter policies.
            //
            // This means that for parameters that have 'out of line' defaults we will modify
            // the parameter to contain the default (same story for parameter policies).
            //
            // We also maintain a collection of defaults and parameter policies that will also
            // contain the values that don't match a parameter.
            //
            // It's important that these two views of the data are consistent. We don't want
            // values specified out of line to have a different behavior.

            Dictionary<string, object> updatedDefaults = null;
            if (defaults != null && defaults.Count > 0)
            {
                updatedDefaults = new Dictionary<string, object>(defaults.Count, StringComparer.OrdinalIgnoreCase);

                foreach (var kvp in defaults)
                {
                    updatedDefaults.Add(kvp.Key, kvp.Value);
                }
            }

            Dictionary<string, List<RoutePatternParameterPolicyReference>> updatedParameterPolicies = null;
            if (parameterPolicies != null && parameterPolicies.Count > 0)
            {
                updatedParameterPolicies = new Dictionary<string, List<RoutePatternParameterPolicyReference>>(parameterPolicies.Count, StringComparer.OrdinalIgnoreCase);

                foreach (var kvp in parameterPolicies)
                {
                    var policyReferences = new List<RoutePatternParameterPolicyReference>();

                    if (kvp.Value is IParameterPolicy parameterPolicy)
                    {
                        policyReferences.Add(ParameterPolicy(parameterPolicy));
                    }
                    else if (kvp.Value is string)
                    {
                        // Constraint will convert string values into regex constraints
                        policyReferences.Add(Constraint(kvp.Value));
                    }
                    else if (kvp.Value is IEnumerable multiplePolicies)
                    {
                        foreach (var item in multiplePolicies)
                        {
                            // Constraint will convert string values into regex constraints
                            policyReferences.Add(item is IParameterPolicy p ? ParameterPolicy(p) : Constraint(item));
                        }
                    }
                    else
                    {
                        throw new InvalidOperationException(Resources.FormatRoutePattern_InvalidConstraintReference(
                            kvp.Value ?? "null",
                            typeof(IRouteConstraint)));
                    }

                    updatedParameterPolicies.Add(kvp.Key, policyReferences);
                }
            }

            List<RoutePatternParameterPart> parameters = null;
            var updatedSegments = segments.ToArray();
            for (var i = 0; i < updatedSegments.Length; i++)
            {
                var segment = VisitSegment(updatedSegments[i]);
                updatedSegments[i] = segment;

                for (var j = 0; j < segment.Parts.Count; j++)
                {
                    if (segment.Parts[j] is RoutePatternParameterPart parameter)
                    {
                        if (parameters == null)
                        {
                            parameters = new List<RoutePatternParameterPart>();
                        }

                        parameters.Add(parameter);
                    }
                }
            }

            // Each Required Value either needs to either:
            // 1. be null-ish
            // 2. have a corresponding parameter
            // 3. have a corrsponding default that matches both key and value
            if (requiredValues != null)
            {
                foreach (var kvp in requiredValues)
                {
                    // 1.be null-ish
                    var found = RouteValueEqualityComparer.Default.Equals(string.Empty, kvp.Value);

                    // 2. have a corresponding parameter
                    if (!found && parameters != null)
                    {
                        for (var i = 0; i < parameters.Count; i++)
                        {
                            if (string.Equals(kvp.Key, parameters[i].Name, StringComparison.OrdinalIgnoreCase))
                            {
                                found = true;
                                break;
                            }
                        }
                    }

                    // 3. have a corrsponding default that matches both key and value
                    if (!found &&
                        updatedDefaults != null &&
                        updatedDefaults.TryGetValue(kvp.Key, out var defaultValue) &&
                        RouteValueEqualityComparer.Default.Equals(kvp.Value, defaultValue))
                    {
                        found = true;
                    }

                    if (!found)
                    {
                        throw new InvalidOperationException(
                            $"No corresponding parameter or default value could be found for the required value " +
                            $"'{kvp.Key}={kvp.Value}'. A non-null required value must correspond to a route parameter or the " +
                            $"route pattern must have a matching default value.");
                    }
                }
            }

            return new RoutePattern(
                rawText,
                updatedDefaults ?? EmptyDictionary,
                updatedParameterPolicies != null
                    ? updatedParameterPolicies.ToDictionary(kvp => kvp.Key, kvp => (IReadOnlyList<RoutePatternParameterPolicyReference>)kvp.Value.ToArray())
                    : EmptyPoliciesDictionary,
                requiredValues ?? EmptyDictionary,
                (IReadOnlyList<RoutePatternParameterPart>)parameters ?? Array.Empty<RoutePatternParameterPart>(),
                updatedSegments);

            RoutePatternPathSegment VisitSegment(RoutePatternPathSegment segment)
            {
                RoutePatternPart[] updatedParts = null;
                for (var i = 0; i < segment.Parts.Count; i++)
                {
                    var part = segment.Parts[i];
                    var updatedPart = VisitPart(part);

                    if (part != updatedPart)
                    {
                        if (updatedParts == null)
                        {
                            updatedParts = segment.Parts.ToArray();
                        }

                        updatedParts[i] = updatedPart;
                    }
                }

                if (updatedParts == null)
                {
                    // Segment has not changed
                    return segment;
                }

                return new RoutePatternPathSegment(updatedParts);
            }

            RoutePatternPart VisitPart(RoutePatternPart part)
            {
                if (!part.IsParameter)
                {
                    return part;
                }

                var parameter = (RoutePatternParameterPart)part;
                var @default = parameter.Default;

                if (updatedDefaults != null && updatedDefaults.TryGetValue(parameter.Name, out var newDefault))
                {
                    if (parameter.Default != null && !Equals(newDefault, parameter.Default))
                    {
                        var message = Resources.FormatTemplateRoute_CannotHaveDefaultValueSpecifiedInlineAndExplicitly(parameter.Name);
                        throw new InvalidOperationException(message);
                    }

                    if (parameter.IsOptional)
                    {
                        var message = Resources.TemplateRoute_OptionalCannotHaveDefaultValue;
                        throw new InvalidOperationException(message);
                    }

                    @default = newDefault;
                }

                if (parameter.Default != null)
                {
                    if (updatedDefaults == null)
                    {
                        updatedDefaults = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
                    }

                    updatedDefaults[parameter.Name] = parameter.Default;
                }

                List<RoutePatternParameterPolicyReference> parameterConstraints = null;
                if ((updatedParameterPolicies == null || !updatedParameterPolicies.TryGetValue(parameter.Name, out parameterConstraints)) &&
                    parameter.ParameterPolicies.Count > 0)
                {
                    if (updatedParameterPolicies == null)
                    {
                        updatedParameterPolicies = new Dictionary<string, List<RoutePatternParameterPolicyReference>>(StringComparer.OrdinalIgnoreCase);
                    }

                    parameterConstraints = new List<RoutePatternParameterPolicyReference>();
                    updatedParameterPolicies.Add(parameter.Name, parameterConstraints);
                }

                if (parameter.ParameterPolicies.Count > 0)
                {
                    parameterConstraints.AddRange(parameter.ParameterPolicies);
                }

                if (Equals(parameter.Default, @default)
                    && parameter.ParameterPolicies.Count == 0
                    && (parameterConstraints?.Count ?? 0) == 0)
                {
                    // Part has not changed
                    return part;
                }

                return ParameterPartCore(
                    parameter.Name,
                    @default,
                    parameter.ParameterKind,
                    parameterConstraints?.ToArray() ?? Array.Empty<RoutePatternParameterPolicyReference>(),
                    parameter.EncodeSlashes);
            }
        }

```


### RoutePatternParser
``` cs
public static RoutePattern Parse(string pattern)
        {
            if (pattern == null)
            {
                throw new ArgumentNullException(nameof(pattern));
            }

            var trimmedPattern = TrimPrefix(pattern);

            var context = new Context(trimmedPattern);
            var segments = new List<RoutePatternPathSegment>();

            while (context.MoveNext())
            {
                var i = context.Index;

                if (context.Current == Separator)
                {
                    // If we get here is means that there's a consecutive '/' character.
                    // Templates don't start with a '/' and parsing a segment consumes the separator.
                    throw new RoutePatternException(pattern, Resources.TemplateRoute_CannotHaveConsecutiveSeparators);
                }

                if (!ParseSegment(context, segments))
                {
                    throw new RoutePatternException(pattern, context.Error);
                }

                // A successful parse should always result in us being at the end or at a separator.
                Debug.Assert(context.AtEnd() || context.Current == Separator);

                if (context.Index <= i)
                {
                    // This shouldn't happen, but we want to crash if it does.
                    var message = "Infinite loop detected in the parser. Please open an issue.";
                    throw new InvalidProgramException(message);
                }
            }

            if (IsAllValid(context, segments))
            {
                return RoutePatternFactory.Pattern(pattern, segments);
            }
            else
            {
                throw new RoutePatternException(pattern, context.Error);
            }
        }
```

あと延々と続くので興味が出たらまたメモをする予定

</details>
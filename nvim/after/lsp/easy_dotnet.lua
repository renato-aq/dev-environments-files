-- Roslyn, started by easy-dotnet. It sends no inlay hints unless they're listed here.
return {
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
		["csharp|completion"] = {
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_show_name_completion_suggestions = true,
		},
		["csharp|symbol_search"] = {
			dotnet_search_reference_assemblies = true,
		},
		["csharp|background_analysis"] = {
			dotnet_analyzer_diagnostics_scope = "openFiles",
			dotnet_compiler_diagnostics_scope = "fullSolution",
		},
	},
}

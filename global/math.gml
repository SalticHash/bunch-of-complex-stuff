// feather disable GM2017
// feather ignore GM2017
/**
 * @function is_operator( character)
 * @pure
 * @param {string} _char	Character to check
 * @description Check if given character is an operator: + - * / ^ ( )
 * @returns {bool}	True if character is one of the 7 operators listed in the description
 */
function is_operator( argument0){
	var _char = argument0
	return
		_char == "+"
		|| _char == "-"
		|| _char == "*"
		|| _char == "/"
		|| _char == "^"
		|| _char == "("
		|| _char == ")";
}

function operation( argument0, argument1, argument2) {
	var _char = argument0
	var _lh = argument1
	var _rh = argument2
	switch (_char) {
		case "+": return _lh + _rh;
		case "-": return _lh - _rh;
		case "*": return _lh * _rh;
		case "/": return _lh / _rh;
		case "^": return power(_lh, _rh);
		default: return 0;
	}
}

/**
 * @function postfix_queue_eval( queue)
 * @param {Id.DsQueue}	_queue	Queue representing postfix expression
 * @description Evaluate a postfix expression
 * @returns {real}	Result
 */
function postfix_queue_eval( argument0){
	var _queue = argument0
	var stack = ds_stack_create();
	
	while( !ds_queue_empty( _queue)){
		var t = ds_queue_dequeue( _queue);
		if( is_operator( t)){
			var rh = ds_stack_pop( stack);
			var lh = ds_stack_pop( stack);

			var result = operation(t, lh, rh)

			ds_stack_push( stack, result);
		}else{
            var v;
			
			if (variable_global_exists(t)) {
				v = variable_global_get(t);
			} else {
				v = real(t);
			}

			ds_stack_push( stack, v);
		}
	}
	
	// Clean up
	var ret = ds_stack_pop( stack);
	
	ds_stack_destroy( stack);
	
	return ret;
}

/**
 * @function parse_math(  expression)
 * @pure
 * @param {string}	_expression	Expression in string form to parse
 * @description Parse a complex math expression
 * @returns {real}	Result of expression
 */
function parse_math( argument0){
	var _expression = argument0
	var operators = ds_stack_create(),
		output = ds_queue_create(),
		tokens = [];
		
	// Create operator priority table
	var priorityTable = ds_map_create(),
		opList = ["+", "-", "*", "/", "^"];
	for( var i = 0; i < array_length( opList); ++i){
		ds_map_add(priorityTable, opList[i], i);
		
	}
	
	// Remove whitespace
	_expression = string_replace_all( _expression, " ", "");
	
	// Split into tokens
	var i = 0;
	while( string_length( _expression) != string_length( string_digits( _expression))){
		var lenExp = string_length( _expression);
			
		if( ++i > lenExp) break;
		
		var c = string_char_at( _expression, i);
		
		if( is_operator( c)){
			// Check if "-" is actually a negative sign
			if( c == "-"){
				if( i == 1){
					var nbTokens = array_length( tokens);
					if( nbTokens == 0 || tokens[nbTokens - 1] != ")"){
						continue;
					}
				}
			}
			
			if( i > 1){
				array_push( tokens, string_copy( _expression, 1, i - 1));
			}
			
			array_push(tokens, c);
			
			_expression = string_copy( _expression, i + 1, string_length( _expression) - i);
			
			i = 0;
		}
	}
	
	if( _expression != "") array_push( tokens, _expression);
	
	// Prepare for evaluation
	var nbTokens = array_length( tokens);
	for( i = 0; i < nbTokens; ++i){
		var t = tokens[i];
		if( is_operator( t)){
			if( t == "("){
				ds_stack_push( operators, t);
				continue;
			}
			
			if( t == ")"){
				var o = ds_stack_pop( operators);
				do{
					ds_queue_enqueue( output, o);
					o = ds_stack_pop( operators);
				}until( o == "(");
				continue;
			}
			
			var p = ds_stack_top( operators);
			if( p == undefined){
				ds_stack_push( operators, t);
				continue;
			}
			
			while( ds_map_find_value(priorityTable, t) < ds_map_find_value(priorityTable, p)){
				ds_queue_enqueue( output, ds_stack_pop( operators));
				p = ds_stack_top( operators);
				if( p == undefined) break;
			}
			
			ds_stack_push( operators, t);
		}else{
			ds_queue_enqueue( output, t);
		}
	}
	
	while( !ds_stack_empty( operators)){
		ds_queue_enqueue( output, ds_stack_pop( operators));
	}
	
	// Evaluate
	var ret = postfix_queue_eval( output);
	
	// Clean up
	ds_stack_destroy( operators);
	ds_queue_destroy( output);
	ds_map_destroy( priorityTable);
	
	return ret;
}
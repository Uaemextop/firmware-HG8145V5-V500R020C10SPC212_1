function DisableAllElement()
{
	var all_input = document.getElementsByTagName("input");
	for (var i = 0; i <all_input.length ; i++) 
	{
		var b_input = all_input[i];
		
		b_input.disabled = "disabled";
	}
	
	var all_button = document.getElementsByTagName("button");
	for (var i = 0; i <all_button.length ; i++) 
	{
		var b_button = all_button[i];
		
		b_button.disabled = "disabled";
	}
	
	var all_select = document.getElementsByTagName("select");
	for (var i = 0; i <all_select.length ; i++) 
	{
		var b_select = all_select[i];
		
		b_select.disabled = "disabled";
	}
	
	var all_textarea = document.getElementsByTagName("textarea");
	for (var i = 0; i <all_textarea.length ; i++) 
	{
		var b_textarea = all_textarea[i];
		
		b_textarea.disabled = "disabled";
	}
}
# Bunch of Complex Stuff (for AFOM)
![A box containing the logo of BOCS, get it?](assets/banner.jpg "Banner")
## The triggers
![Object variable sprite](assets/obj_variable.png "obj_variable")
![Object get variable sprite](assets/obj_getvar.png "obj_getvar")
![Object delay sprite](assets/obj_delay.png "obj_delay")
![Object compare sprite](assets/obj_compare.png "obj_compare")

*Video explanation coming soon!*

A mod for Pizza Tower's "Another Fixed Objects Mod", this mod offers triggers and
more complex features for AFOM, the full list of additions is listed down below.

<ul>
    <li>
        Added <code>obj_variable</code>, <code>obj_delay</code>, <code>obj_getvar</code> and <code>obj_compare</code>,
        all of them children of <code>obj_trigger</code>.
    </li>
    <li>
        Added the ability to use global variables as values for object's variables.
    </li>
</ul>

<br>

Sound like not a lot but it's very powerful.

## obj_trigger
<pre>
// The ID of this trigger
trigger_id = -1;

// The ID of the trigger to be triggered if this trigger executes properly
target_trigger_id = -1;

// Execute on room start
on_enter = true;

// Execute when player inside
on_touch = false;

// Execute when triggered by other triggers
on_trigger = false;

// Execute every frame (ignores multi)
on_repeat = false;

// Execute even if executed before, else just execute one time.
multi = false;

// Activated (ignored if multi)
activated = false;
</pre>

## obj_variable
<pre>
// The name of the global variable to set
name = "panic";
    
// The value to set it to
value = true;
</pre>

## obj_delay
<pre>
// The delay in seconds to trigger target trigger
delay = 1;
</pre>

## obj_compare
<pre>
// The values to compare
a = 5;
b = 10;
    
// The operation to check: =, !=, &gt;, &lt;, &gt;=, &lt;=, or, and.
op = "=";
</pre>

## obj_getvar
<pre>
// The object you want to get a variable from.
target_obj = obj_player
    
// The local variable of the object.
target_var = "x"
    
// The global variable to set it to.
target_global_var = "player_x"
</pre>

## Variable access
<code>v_</code> or <code>vs_</code> before a local variable name, sets a global variable
to a local one, <code>v_</code> for each frame and <code>vs_</code> for on room start, example

<code>v_x = panic;</code> in this case the x position of the object is the value of the global variable
panic.

## Variable definition
<code>g_</code> or <code>gs_</code> before a global variable name, sets a local variable to a global
one, <code>g_</code> for each frame and <code>gs_</code> for on room start,
example <code>g_pepx = x</code> in this case the global variable pepx is set to the x of the object each
frame, very similar to obj_getvar, but obj_getvar is for objects that you can't set this variable in like peppino.

## Operations
Where each operation starts with zero and then the front operation is evaluated.
<pre>
op=,+panic,*100,
op=,-100,+100,
op=,+glob1,+glob2,
op=,+6,*7,/4,
</pre>
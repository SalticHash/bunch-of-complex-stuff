if (on_start && (!activated))
{
    self.execute()
    if (!multi)
        activated = 1;
}
if (on_enter && (!activated))
{
    self.execute()
    if (!multi)
        activated = 1;
}
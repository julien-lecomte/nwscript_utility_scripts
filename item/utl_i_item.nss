//::///////////////////////////////////////////////
//:: Utility Include: Item
//:: utl_i_item.nss
//:://////////////////////////////////////////////
/*
    A number of item utility functions including functions to manipulate
    inventories of objects (which contain items).
*/
//:://////////////////////////////////////////////
//:: Part of the nwscript_utility_scripts project; see for dates/creator info
//:: https://github.com/Finaldeath/nwscript_utility_scripts
//:://////////////////////////////////////////////

// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject);

// Destroys all the items in the inventory of oObject that matches the resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - item resref to check
void DestroyAllItemsByResRef(object oObject, string sResRef);

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - item tag to check
void DestroyAllItemsByTag(object oObject, string sTag);

// Makes all items in the inventory/equipped items of oObject flagged as droppable (and cursed) or not
// * oObject - a placeable, store, creature or container
// * bDroppable - If TRUE it will set the droppable flag to TRUE and cursed to FALSE.
//                If FALSE it does the opposite and sets droppable flag to FALSE and cursed flag to TRUE
void SetInventoryDroppable(object oObject, int bDroppable = TRUE);


// Destroys all the items in the inventory of oObject
// Creatures also have all equipped items destroyed
// * oObject - a placeable, store, creature or container
void ClearInventory(object oObject)
{
    // In case we're passed something else
    if(!GetHasInventory(oObject)) return;

    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        // Boxes in inventories
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem))
            {
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Clear inventory slots as well for creatures
    if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
            DestroyObject(GetItemInSlot(i, oObject));
    }
}


// Destroys all the items in the inventory of oObject that matches the resref
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sResRef - item resref to check
void DestroyAllItemsByResRef(object oObject, string sResRef)
{
    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(oItem2 != OBJECT_INVALID)
            {
                if(FindSubString(sResRef, GetResRef(oItem2)) >= 0)
                    DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }

        if (FindSubString(sResRef, GetResRef(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if(FindSubString(sResRef, GetResRef(oItem)) >= 0)
                DestroyObject(oItem);
        }
    }
}

// Destroys all the items in the inventory of oObject that matches the tag
// Creatures also have all equipped items checked
// * oObject - a placeable, store, creature or container
// * sTag - item tag to check
void DestroyAllItemsByTag(object oObject, string sTag)
{
    object oItem = GetFirstItemInInventory(oObject);
    while(GetIsObjectValid(oItem))
    {
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(oItem2 != OBJECT_INVALID)
            {
                if(FindSubString(sTag, GetTag(oItem2)) >= 0)
                    DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }

        if (FindSubString(sTag, GetTag(oItem)) >= 0)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oObject);
    }
    // Check inventory slots as well for creatures
    if(GetObjectType(oObject) == OBJECT_TYPE_CREATURE)
    {
        int i;
        for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
        {
            oItem = GetItemInSlot(i, oObject);
            if(FindSubString(sTag, GetTag(oItem)) >= 0)
                DestroyObject(oItem);
        }
    }
}

// Makes all items in the inventory/equipped items of oObject flagged as droppable (and cursed) or not
// * oObject - a placeable, store, creature or container
// * bDroppable - If TRUE it will set the droppable flag to TRUE and cursed to FALSE.
//                If FALSE it does the opposite and sets droppable flag to FALSE and cursed flag to TRUE
void SetInventoryDroppable(object oObject, int bDroppable = TRUE)
{
    int bCursed = TRUE;
    if(bDroppable) bCursed = FALSE;

    // Set all the clones items to be undroppable so cannot be retrieved on death
    object oItem = GetFirstItemInInventory(oClone);
    while(GetIsObjectValid(oItem))
    {
        // Boxes in inventories
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem))
            {
                SetItemCursedFlag(oItem2, bCursed);
                SetDroppableFlag(oItem2, bDroppable);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        SetItemCursedFlag(oItem, bCursed);
        SetDroppableFlag(oItem, bDroppable);
        oItem = GetNextItemInInventory(oClone);
    }
    // Sort inventory slots as well
    int i;
    for(i = 0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i, oClone);
        SetItemCursedFlag(oItem, bCursed);
        SetDroppableFlag(oItem, bDroppable);
    }
}
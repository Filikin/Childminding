/*
Author: Eamon Kelly, Enclude
Purpose: Create an org related to this contact - allows the non profit pack org to remain
Called from: Trigger
*/
trigger CreateRelatedOrgOnContactTrigger on Contact (before insert) 
{
	for(Contact c : Trigger.new)
    {
    	if (isValid (c.Related_Org_name__c))
    	{
    		Account relatedAccount=null;
	    	try
    		{
    			relatedAccount = [select id from Account where Name=:c.Related_Org_name__c limit 1];
    		}
    		catch (Exception e)
    		{
    			// assuming this is a account not found exception, so create a new one
    			relatedAccount = new Account(Name=c.Related_Org_name__c);
    			insert relatedAccount;
    		}
    		c.Related_Organisation__c = relatedAccount.id;
    		if (isValid(c.MailingStreet)) relatedAccount.BillingStreet = c.MailingStreet;
    		if (isValid(c.MailingState)) relatedAccount.BillingState = c.MailingState;
    		if (isValid(c.MailingCity)) relatedAccount.BillingCity = c.MailingCity;
    		if (isValid(c.MailingPostalCode)) relatedAccount.BillingPostalCode = c.MailingPostalCode;
    		update relatedAccount;
    	}
    }

	public static boolean isValid (String text)
	{
		if (text <> null && text <> '' && text <> '[not provided]') return true;
		else return false;
	}
/*
	public static boolean isValid (Decimal numb)
	{
		if (numb <> null && numb > 0.0) return true;
		else return false;
	}

	public static boolean isValid (Integer numb)
	{
		if (numb <> null && numb > 0) return true;
		else return false;
	}
*/
}
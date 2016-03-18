<!--- CFWebstore, version 6.50 --->

<!--- This template is used for outputting the average rating for a product and is called by dsp_reviews_inline.cfm --->
<cfoutput>
<!-- start product/reviews/put_rating.cfm -->
<div id="putrating" class="product">
Average Customer Rating: <img src="#Request.ImagePath#icons/#round(qry_prod_reviews.Avg_Rating)#_lg_stars.gif" alt="" />
(<cfif qry_prod_reviews.Avg_Rating gt 4>Excellent<cfelseif qry_prod_reviews.Avg_Rating gt 3>Very Good<cfelseif qry_prod_reviews.Avg_Rating gte 2>Average<cfelseif qry_prod_reviews.Avg_Rating gte 1>Below Average<cfelseif qry_prod_reviews.Avg_Rating gt 0>Poor<cfelse>Not Ranked</cfif>) 
based on #qry_prod_reviews.recordcount# review<cfif qry_prod_reviews.recordcount neq 1>s</cfif><br/>
</div>
<!-- end product/reviews/put_rating.cfm -->
</cfoutput>
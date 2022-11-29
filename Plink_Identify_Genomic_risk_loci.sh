refdir=/scratch/ys98038/UKB/plink2_format/PUFA_GWAS/Summary_statistics
pgen=https://www.dropbox.com/s/afvvf1e15gqzsqo/all_phase3.pgen.zst?dl=1
pvar=https://www.dropbox.com/s/op9osq6luy3pjg8/all_phase3.pvar.zst?dl=1
sample=https://www.dropbox.com/s/yozrzsdrwqej63q/phase3_corrected.psam?dl=1
wget $pgen
mv 'all_phase3.pgen.zst?dl=1' all_phase3.pgen.zst
plink2 --zst-decompress all_phase3.pgen.zst > all_phase3.pgen
wget $pvar
mv 'all_phase3.pvar.zst?dl=1' all_phase3.pvar.zst
plink2 --zst-decompress all_phase3.pvar.zst > all_phase3.pvar
wget $sample
mv 'phase3_corrected.psam?dl=1' all_phase3.psam

# ml PLINK/2.00-alpha2.3-x86_64-20210920-dev
plink2 --pfile $refdir/all_phase3  --max-alleles 2  --make-bed  --out $refdir/all_phase3
mv $refdir/all_phase3.log $refdir/log

plink2 --pfile $refdir/all_phase3  --max-alleles 2  --make-bed --keep-cat-pheno SuperPop --keep-cat-names EUR --out $refdir/all_phase3_EUR


# ml PLINK/1.9b_5-x86_64
# Error: Duplicate ID 'rs538876409'.
cut -f 2 $refdir/all_phase3.bim | sort | uniq -d > $refdir/all_phase3.dups
plink --bfile $refdir/all_phase3 --allow-extra-chr --exclude $refdir/all_phase3.dups --make-bed --out $refdir/all_phase3_no_dups

cut -f 2 $refdir/all_phase3_EUR.bim | sort | uniq -d > $refdir/all_phase3_EUR.dups
plink --bfile $refdir/all_phase3_EUR --allow-extra-chr --exclude $refdir/all_phase3_EUR.dups --make-bed --out $refdir/all_phase3_EUR_no_dups

plink --bfile $refdir/all_phase3 --list-duplicate-vars --allow-extra-chr --out $refdir/all_phase3
plink --bfile $refdir/all_phase3_no_dups --allow-extra-chr --exclude $refdir/all_phase3.dupvar --make-bed --out $refdir/all_phase3_final

plink --bfile $refdir/all_phase3_EUR --list-duplicate-vars --allow-extra-chr --out $refdir/all_phase3_EUR
plink --bfile $refdir/all_phase3_EUR_no_dups --allow-extra-chr --exclude $refdir/all_phase3_EUR.dupvar --make-bed --out $refdir/all_phase3_EUR_final

##########Derivation of independent loci
# Once we performed the GWAS, full summary statistics were clumped to r2 > 0.1 using the following clump command.
# plink1.9 --bfile <1000G Phase 3 European plink file> --clump <summary statistics> --clump-p1 1e-6 --clump-p2 1e-4 --clump-r2 0.1 --clump-kb 10000 --clump-field P --clump-snp-field ID
#plink --bfile $refdir/all_phase3_final --clump $refdir/Summary_statistics_MAGNETIC_FAw3.txt -out $refdir/Summary_statistics_MAGNETIC_FAw3 --allow-extra-chr --clump-p1 1e-6 --clump-p2 1e-4 --clump-r2 0.1 --clump-kb 10000 --clump-field p-value --clump-snp-field ID

# ml PLINK/1.9b_5-x86_64
# refdir=/scratch/ys98038/UKB/plink2_format/PUFA_GWAS/Summary_statistics
# plink --bfile $refdir/all_phase3_EUR_final --clump $refdir/META_IVW_FAw31.txt --clump-range  glist-hg19 -out $refdir/Test_META_IVW_FAw3 --allow-extra-chr  --clump-p1 5e-8 --clump-p2 0.05  --clump-r2 0.1 --clump-kb 250 --clump-field P-value --clump-snp-field MarkerName

# ml PLINK/1.9b_5-x86_64
refdir=/scratch/ys98038/UKB/plink2_format/PUFA_GWAS/Summary_statistics

plink --bfile $refdir/all_phase3_EUR_final --clump $refdir/metc_Omega3.txt --clump-range  glist-hg19 -out $refdir/Test_metc_Omega3 --allow-extra-chr  --clump-p1 5e-8 --clump-p2 0.05  --clump-r2 0.1 --clump-kb 250 --clump-field pval.exposure --clump-snp-field SNP
